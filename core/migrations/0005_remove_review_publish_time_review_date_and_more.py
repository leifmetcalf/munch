# Generated by Django 5.1 on 2024-08-23 10:14

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0004_alter_restaurant_notes'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='review',
            name='publish_time',
        ),
        migrations.AddField(
            model_name='review',
            name='date',
            field=models.DateField(default=datetime.date(2024, 8, 23), verbose_name='date of meal'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='review',
            name='rating',
            field=models.IntegerField(verbose_name='rating'),
        ),
        migrations.AlterField(
            model_name='review',
            name='text',
            field=models.CharField(max_length=1000, verbose_name='review text'),
        ),
    ]
