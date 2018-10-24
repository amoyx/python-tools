# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-05-06 02:37
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('online', '0002_auto_20160506_1034'),
    ]

    operations = [
        migrations.AlterField(
            model_name='compose',
            name='container_flag',
            field=models.IntegerField(choices=[(1, 1), (2, 2)], verbose_name='\u524d\u4e00\u4e2a\u5bb9\u5668\u5e8f\u53f7'),
        ),
        migrations.AlterField(
            model_name='compose',
            name='default_port',
            field=models.IntegerField(choices=[(8080, 8080), (80, 80)], default=80, null=True, verbose_name='\u9ed8\u8ba4\u7aef\u53e3'),
        ),
    ]
