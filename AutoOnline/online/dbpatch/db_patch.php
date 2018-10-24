<?php
/**
 * Database patch tool
 *
 * Created by PhpStorm.
 * User: root
 * Date: 1/15/16
 * Time: 1:05 PM
 */

$on_error_continue = true;
$verbose = true;        //Show all sql will execute
$patch_path = ".";     //patch file path

$ver_flag_match = "/--[\t ]*?###[\t ]*?VERSION: ([\d\.]+?)[\t ]*?###[\t ]*?--/";     //The version flag in sql file

require_once("db_conf.php");

function get_conn() {
    global $db_host, $db_user, $db_pass, $db_name, $db_port;

    $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name, $db_port);

    if($mysqli->connect_errno) {
        echo "Error: Unable to connect to MySQL. " . PHP_EOL;
        echo "Error: " . $mysqli->connect_error . PHP_EOL;
        return false;
    }
    if (!$mysqli->set_charset("utf8")) {
        echo "Error loading character set utf8: ".$mysqli->error . PHP_EOL;
        return false;
    }
    return $mysqli;
}

/**
 * Get the lasted version of database
 *
 * @param mysqli $mysqli
 * @return bool
 */
function get_base_ver(mysqli $mysqli){
    if(!check_table_exist("VER_DATABASE", $mysqli)){
        $sql = "CREATE TABLE `VER_DATABASE` ( "
            ."`DATABASE_VERSION` varchar(30) NOT NULL COMMENT '数据库版本',"
            ."`UPDATE_SQL` text DEFAULT NULL COMMENT '更新SQL脚本',"
            ."`UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',"
            ."UNIQUE KEY `idx_version` (`DATABASE_VERSION`) USING BTREE"
            .") ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据库版本更新记录';";
        $sql1 = "INSERT INTO `ver_database` (DATABASE_VERSION, UPDATE_SQL, UPDATE_TIME) VALUES ('1.0.0', '-- Init version table.', now());";

        if(!$mysqli->query($sql)){
            echo "Create table [VER_DATABASE] failed." . $mysqli->error . PHP_EOL;
            return false;
        }
        if(!$mysqli->query($sql1)){
            echo "Init database version failed." . $mysqli->error . PHP_EOL;
            return false;
        }
    }
    $res = $mysqli->query("SELECT DATABASE_VERSION FROM VER_DATABASE");

    if(!$res){
        echo "Query databse lasted version failed.".PHP_EOL;
        echo "Error: " . $mysqli->error . PHP_EOL;
        return false;
    }

    $_ver = false;
    while($row = $res->fetch_assoc()){
        if(!$_ver)
            $_ver= $row["DATABASE_VERSION"];
        else {
            $_v = $row["DATABASE_VERSION"];
            if(compare_version($_v, $_ver)>0){
                $_ver = $_v;
            }
        }
    }

    $res->free();
    return $_ver;
}

function check_table_exist($table_name, mysqli $mysqli){
    if ($result = $mysqli->query("SHOW TABLES LIKE '".$table_name."'")) {
        if($obj = $result->fetch_object()){
            return true;
        }
    }
    return false;
}

/**
 * Compare two version string,
 * if $ver1 > $ver2 then return 1;
 * if $ver1 = $ver2 then return 0;
 * if $ver1 < $ver2 then return -1;
 *
 * @param $ver1
 * @param $ver2
 * @return int
 */
function compare_version($ver1, $ver2){
    $ret = false;
    if($ver1 == $ver2) return 0;
    $verArr1 = explode(".", $ver1);
    $verArr2 = explode(".", $ver2);
    $count = count($verArr1) < count($verArr2) ? count($verArr1) : count($verArr2);
    for($ii = 0; $ii < $count; $ii++){
        if((int)$verArr1[$ii] > (int)$verArr2[$ii])
            return 1;
        if((int)$verArr1[$ii] < (int)$verArr2[$ii])
            return -1;
    }

    if(count($verArr1) > count($verArr2)) return 1;
    if(count($verArr1) < count($verArr2)) return -1;
    return 0;
}

/**
 * Get SQL file list
 * @param string $dirname
 * @return array|bool
 */
function get_file_list($dirname = "./"){
    $dir_handle=opendir($dirname);
    if(!$dir_handle){
        echo "Open directory faied." . PHP_EOL;
        return false;
    }

    $files = array();

    while($file = readdir($dir_handle)){
        // Skip '.' and '..'
        if( $file == '.' || $file == '..')
            continue;
        $path = $dirname . '/' . $file;
        if( is_dir($path) )
            //$files += rec_listFiles($path);
            continue;
        else {
            if(preg_match("/\.sql$/i", $file) && file_exists($path)){
                $files[] = $path;
            }
        }
    }
    closedir($dir_handle);
    return $files;
}

/**
 * Load sql statements from file
 *
 * @param $file
 * @return bool|string
 */
function load_sql_file($file){
    $sql = false;
    if(file_exists($file)){
        $sql = file_get_contents($file);
    }
    return $sql;
}

/**
 *
 * @param $sqlStr
 * @return bool
 */
function parse_ver_from_file($sqlStr){
    global $ver_flag_match;
    $ver = false;

    if(preg_match($ver_flag_match, $sqlStr, $matches)){
        $ver = $matches[1];
    }

    return $ver;
}

/**
 * Load sql statements from file.
 *
 * @param $fileList
 * @return array
 */
function load_sql_files($fileList){
    $_arr = array();
    foreach($fileList as $file){
        $sqlStr = load_sql_file($file);
        if(!$sqlStr){
            echo "Load file [".$file."] failed." . PHP_EOL;
            continue;
        }
        $_ver = parse_ver_from_file($sqlStr);
        if(!$_ver){
            echo "Parse version from file [".$file."] failed." . PHP_EOL;
            continue;
        }
        $_arr[] = array("file_name" => $file, "version" => $_ver, "sql_str" => $sqlStr);
    }
    return $_arr;
}

/**
 * Sort file by version
 * Test case:
 *
$arr = array(
array("file_name"=>"file 1", "version"=>"1.0.3.12", "sqls"=>""),
array("file_name"=>"file 3", "version"=>"1.0.3.31", "sqls"=>""),
array("file_name"=>"file 4", "version"=>"1.0.3.5", "sqls"=>""),
array("file_name"=>"file 2", "version"=>"1.0.3.2.9", "sqls"=>""),
array("file_name"=>"file 6", "version"=>"1.0.3.4", "sqls"=>""),
array("file_name"=>"file 9", "version"=>"1.0.3.9", "sqls"=>""),
array("file_name"=>"file 41", "version"=>"1.0.4.1", "sqls"=>""),
array("file_name"=>"file 2033", "version"=>"2.0.3.3", "sqls"=>""),
array("file_name"=>"file 131", "version"=>"1.1.3.1", "sqls"=>"")
);
sort_sql_files_by_ver($arr);
print_r($arr);

 * @param $fileArray
 */
function sort_sql_files_by_ver(&$fileArray){
    function my_sort($a,$b)
    {
        return compare_version($a["version"], $b["version"]);
    }
    uasort($fileArray, "my_sort");
}

/**
 * Remove files that version is less than base version from list
 * @param $base_ver
 * @param $fileArray
 */
function filter_sql_files($base_ver, &$fileArray){
    foreach( $fileArray as $key=>$value){
        $ver = $value["version"];
        if(compare_version($value["version"], $base_ver) < 1){
            unset($fileArray[$key]);
        }
    }
}


//
// remove_comments will strip the sql comment lines out of an uploaded sql file
// specifically for mssql and postgres type files in the install....
//
function remove_comments(&$output)
{
    $output = str_replace("\r\n", "\n", $output);
    //$output = preg_replace("/\n{2,}/", "\n", preg_quote($output));
    $lines = explode("\n", $output);
    $output = "";

    foreach($lines as $key=>$sql){
        $sql = preg_replace("/--.+?$/", "", $sql);
        $sql = preg_replace("/#.+?$/", "", $sql);
        $sql = preg_replace("/drop .+?$/i", "", $sql);   //Remove "drop XXXXX " sql
        $sql = remove_utf8_bom($sql);
        $sql = trim($sql);
        $len = strlen($sql);
        $ret = strcmp("", trim($sql));

        if($ret == 0)
            unset($lines[$key]);
    }
    // try to keep mem. use down
    $linecount = count($lines);
    $in_comment = false;
    //for($i = 0; $i < $linecount; $i++)
    foreach($lines as $key=>$val)
    {
        if( preg_match("/^\/\*/", preg_quote($val)) )
        {
            $in_comment = true;
        }
        if( !$in_comment )
        {
            $output .= $val . "\n";
        }
        if( preg_match("/\*\/$/", preg_quote($val)) )
        {
            $in_comment = false;
        }
    }
    unset($lines);
    return $output;
}

function remove_utf8_bom($text)
{
    $bom = pack('H*','EFBBBF');
    $text = preg_replace("/^$bom/", '', $text);
    return $text;
}

//
// remove_remarks will strip the sql comment lines out of an uploaded sql file
//
function remove_remarks($sql)
{
    $lines = explode("\n", $sql);

    // try to keep mem. use down
    $sql = "";

    $linecount = count($lines);
    $output = "";
    for ($i = 0; $i < $linecount; $i++)
    {
        if (($i != ($linecount - 1)) || (strlen($lines[$i]) > 0))
        {

            if ($lines[$i][0] != "#")
            {
                $output .= $lines[$i] . "\n";
            }
            else
            {
                $output .= "\n";
            }
            // Trading a bit of speed for lower mem. use here.
            $lines[$i] = "";
        }
    }

    return $output;

}
//
// split_sql_file will split an uploaded sql file into single sql statements.
// Note: expects trim() to have already been run on $sql.
//
function split_sql_file($sql, $delimiter)
{
    // Split up our string into "possible" SQL statements.
    $tokens = explode($delimiter, $sql);
    // try to save mem.
    $sql = "";
    $output = array();

    // we don't actually care about the matches preg gives us.
    $matches = array();

    // this is faster than calling count($oktens) every time thru the loop.
    $token_count = count($tokens);
    for ($i = 0; $i < $token_count; $i++)
    {
        // Don't wanna add an empty string as the last thing in the array.
        if (($i != ($token_count - 1)) || (strlen($tokens[$i] > 0)))
        {
            // This is the total number of single quotes in the token.
            $total_quotes = preg_match_all("/'/", $tokens[$i], $matches);
            // Counts single quotes that are preceded by an odd number of backslashes,
            // which means they're escaped quotes.
            $escaped_quotes = preg_match_all("/(?<!\\\\)(\\\\\\\\)*\\\\'/", $tokens[$i], $matches);

            $unescaped_quotes = $total_quotes - $escaped_quotes;

            // If the number of unescaped quotes is even, then the delimiter did NOT occur inside a string literal.
            if (($unescaped_quotes % 2) == 0)
            {
                // It's a complete sql statement.
                $output[] = $tokens[$i];
                // save memory.
                $tokens[$i] = "";
            }
            else
            {
                // incomplete sql statement. keep adding tokens until we have a complete one.
                // $temp will hold what we have so far.
                $temp = $tokens[$i] . $delimiter;
                // save memory..
                $tokens[$i] = "";

                // Do we have a complete statement yet?
                $complete_stmt = false;

                for ($j = $i + 1; (!$complete_stmt && ($j < $token_count)); $j++)
                {
                    // This is the total number of single quotes in the token.
                    $total_quotes = preg_match_all("/'/", $tokens[$j], $matches);
                    // Counts single quotes that are preceded by an odd number of backslashes,
                    // which means they're escaped quotes.
                    $escaped_quotes = preg_match_all("/(?<!\\\\)(\\\\\\\\)*\\\\'/", $tokens[$j], $matches);

                    $unescaped_quotes = $total_quotes - $escaped_quotes;

                    if (($unescaped_quotes % 2) == 1)
                    {
                        // odd number of unescaped quotes. In combination with the previous incomplete
                        // statement(s), we now have a complete statement. (2 odds always make an even)
                        $output[] = $temp . $tokens[$j];
                        // save memory.
                        $tokens[$j] = "";
                        $temp = "";

                        // exit the loop.
                        $complete_stmt = true;
                        // make sure the outer loop continues at the right point.
                        $i = $j;
                    }
                    else
                    {
                        // even number of unescaped quotes. We still don't have a complete statement.
                        // (1 odd and 1 even always make an odd)
                        $temp .= $tokens[$j] . $delimiter;
                        // save memory.
                        $tokens[$j] = "";
                    }

                } // for..
            } // else
        }
    }
    return $output;
}

/**
 *
 * Split sql file to sql array
 *
 * @param $sqlStr
 * @return array|bool|string
 */
function split_sql_file_to_array($sqlStr){
    /*
    $sqlStr = str_replace("\r\n", "\n", $sqlStr);
    $sqlStr = preg_replace("/\/\*.+?\*\//", "", $sqlStr);
    $sqlarr = explode("\n", $sqlStr);
    foreach($sqlarr as $key=>$sql){
        $sql = preg_replace("/--.+?$/", "", $sql);
        $sql = preg_replace("/#.+?$/", "", $sql);
        $sql = remove_utf8_bom($sql);
        if(trim($sql) == "")
            unset($sqlarr[$key]);
    }
    return $sqlStr;
    */
    $sqlArr = explode(";", $sqlStr);
    return $sqlArr;
}

/**
 * Batch execute sql
 * @param $sqlArray
 * @param mysqli $mysqli
 */
function exec_batch_sql($sqlArray, mysqli $mysqli){
    global $verbose;
    $result = true;
    foreach($sqlArray as $sql)
    {
        $sql = trim($sql);
        if(strcmp(trim($sql), "") == 0){
            continue;
        }
//        if(isset($verbose) && $verbose){
//            echo $sql . ";" . PHP_EOL;
//        }
        if(!$mysqli->query($sql)){
            echo "Execute sql failed, Error: " . $mysqli->error . PHP_EOL . ", SQL: " . PHP_EOL . $sql . PHP_EOL;
            $result = false;
        };
    }
    return $result;
}

/**
 * Execute sql file by batch
 * @param $sqlStrArray
 */
function execute_batch_sql_file($sqlStrArray, mysqli $mysqli){
    global $verbose;

    /* Prepared statement, stage 1: prepare */
    if (!($pstmt = $mysqli->prepare("INSERT INTO `ver_database`(DATABASE_VERSION, UPDATE_SQL, UPDATE_TIME) VALUES (?, ?, now())"))) {
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error . PHP_EOL;
        return false;
    }

    foreach($sqlStrArray as $sqlFile){

        if(isset($verbose) && $verbose){
            echo "Executing file [".$sqlFile["file_name"]."]" . PHP_EOL;
        }

        $sqlStr = $sqlFile["sql_str"];
        $sqlStr = remove_comments($sqlStr);
        $sqlArray = split_sql_file_to_array($sqlStr);
        if(!$sqlArray){
            echo "Split sql file [".$sqlFile["file_name"]."] content to array file." . PHP_EOL;
            continue;
        }
        $mysqli->begin_transaction();
        $result = exec_batch_sql($sqlArray, $mysqli);
        if(!$result){
            echo "Sone errors occurend when execute sql file [" . $sqlFile["file_name"] . "] by batch, please check the console info.";
            $mysqli->rollback();
            continue;
        }
        //Insert patch log
        $pstmt->bind_param("ss", $sqlFile["version"], $sqlFile["sql_str"]);
        if(!$pstmt->execute()){
            echo "Save database version faied. Error: : (" . $pstmt->errno . ") " . $pstmt->error . PHP_EOL;
            $mysqli->rollback();
        }else{
            $mysqli->commit();
        }

//        if(isset($verbose) && $verbose){
//            echo "Execute file [".$sqlFile["file_name"]."] finished." . PHP_EOL . PHP_EOL;
//        }
    }

    return true;
}

function free(mysqli $mysqli){
    $mysqli->close();
}


function show_usage(){
    $msg = <<<_MSG_
===================================
”跨境通“系统数据库发布版本管理工具。
===================================
用法：
php db_patch.php

更详细用法请阅读 REMEAD.md
-----------------------------------


_MSG_;
    echo $msg . PHP_EOL;
}

/************************TEST **************************
$arr = array(
    array("file_name"=>"file 1", "version"=>"1.0.3.12", "sqls"=>""),
    array("file_name"=>"file 3", "version"=>"1.0.3.31", "sqls"=>""),
    array("file_name"=>"file 4", "version"=>"1.0.3.5", "sqls"=>""),
    array("file_name"=>"file 2", "version"=>"1.0.3.2.9", "sqls"=>""),
    array("file_name"=>"file 6", "version"=>"1.0.3.4", "sqls"=>""),
    array("file_name"=>"file 9", "version"=>"1.0.3.9", "sqls"=>""),
    array("file_name"=>"file 41", "version"=>"1.0.4.1", "sqls"=>""),
    array("file_name"=>"file 2033", "version"=>"2.0.3.3", "sqls"=>""),
    array("file_name"=>"file 131", "version"=>"1.1.3.1", "sqls"=>"")
);
sort_sql_files_by_ver($arr);
print_r($arr);

filter_sql_files("1.0.3.4", $arr);

print_r($arr);

*/


/*********************************************/
show_usage();

$mysqli = get_conn();
if(!$mysqli){
    echo "Connect to database [" . $db_host . "] failed." . PHP_EOL;
    exit();
}

$base_ver = get_base_ver($mysqli);
if(!$base_ver){
    echo "Load lasted version from database failed." . PHP_EOL;
    free($mysqli);
    exit();
}

if(!isset($patch_path)) $patch_path = "./";
$filelist = get_file_list($patch_path);
if(count($filelist)<1){
    echo "No patch need to execute.". PHP_EOL;
    free($mysqli);
    exit();
}

$sqlStrArray = load_sql_files($filelist);

sort_sql_files_by_ver($sqlStrArray);

filter_sql_files($base_ver, $sqlStrArray);
if(count($sqlStrArray)<1){
    echo "Current version [".$base_ver."] is lastest, no patch need to be execute." . PHP_EOL;
    exit();
}

if(!execute_batch_sql_file($sqlStrArray, $mysqli)){
    free($mysqli);
    exit();
}

free($mysqli);

echo "Database patched, current version is [".$base_ver."]." . PHP_EOL;
