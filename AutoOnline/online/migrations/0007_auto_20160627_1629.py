# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-06-27 08:29
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('online', '0006_auto_20160518_1551'),
    ]

    operations = [
        migrations.AlterField(
            model_name='compose',
            name='img_version',
            field=models.CharField(max_length=50, verbose_name='docker\u6700\u540e\u955c\u50cf\u7248\u672c'),
        ),
    ]
