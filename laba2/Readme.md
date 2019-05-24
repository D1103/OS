# Лабораторная работа №2
## Задание 1 (Установка ОС и настройка LVM, RAID)
1. Создание новой виртуальной машины, выдав ей следующие характеристики:
* 1 gb ram
* 1 cpu
* 2 hdd (назвав их ssd1, ssd2 и назначил равный размер, поставив галочки hot swap и ssd)
* SATA контроллер настроен на 4 порта

![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/screen1.JPG)

* Настройка отдельного раздела под /boot: Выбрав первый диск, создал на нем новую таблицу разделов
    + Partition size: 512M
    + Mount point: /boot
    + Повторил настройки для второго диска, выбрав mount point:none
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_02_17.png)
* Настройка RAID
    + Выбрал свободное место на первом диске и настроил в качестве типа раздела physical volume for RAID
    + Выбрал "Done setting up the partition"
    + Повторил настройку для второго диска
* Выбрал пункт "Configure software RAID"
    + Create MD device
    + Software RAID device type: Выберал зеркальный массив
    + Active devices for the RAID XXXX array: Выбрал оба диска
    + Spare devices: Оставил 0 по умолчанию
    + Active devices for the RAID XX array: Выбрал разделы, которые создавал под raid
    + Finish
* В итоге получил: 
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_02_55.png)
* Настройка LVM: Выбрал Configure the Logical Volume Manager
    + Keep current partition layout and configure LVM: Yes
    + Create volume group
    + Volume group name: system
    + Devices for the new volume group: Выбрал созданный RAID
    + Create logical volume
    + logical volume name: root
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: var
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: log
    + logical volume size: 1\5 от размера диска
     + Выбрав Display configuration details получил следующую картину: 
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_03_50.png)
    + Завершив настройку LVM увидел следующее:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_04_16.png)
* Разметка разделов: по-очереди выбрал каждый созданный в LVM том и разметил их, например, для root так:
    + Use as: ext4
    + mount point: /
    + повторил операцию разметки для var и log выбрав соответствующие точки монтирования (/var и /var/log), получив следующий результат:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_05_09.png)
* Финальный результат получился вот таким:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_05_49.png)
2. Закончил установку ОС, поставив grub на первое устройство (sda) и загрузил систему.
3. Выполнил копирование содержимого раздела /boot с диска sda (ssd1) на диск sdb (ssd2)
4. Выполнил установку grub на второе устройство:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_36_28.png)
* Результат команды fdisk -l:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_30_03.png)
* Результат команды lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT:
    + sda - ssd1
    + sdb -ssd2
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_37_07.png)
* Посмотрел информацию о текущем raid командой cat /proc/mdstat:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_38_09.png)
Увидел, что активны два raid1 sda2[0] и sdb2[1]
* Выводы команд: pvs, vgs, lvs, mount:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_39_09.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/1/VirtualBox_os_24_05_2019_18_39_21.png)
* С помощью этих команд увидел информацию об physical volumes, volume groups, logical volumes, примонтированных устройств.
## Вывод
В этом задании научился устанавливать ОС Linux, настраивать LVM и RAID, а также ознакомился с командами:
 * lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
 * fdisk -l
 * pvs,lvs,vgs
 * cat /proc/mdstat
 * mount
 * dd if=/dev/xxx of=/dev/yyy
 * grub-install /dev/XXX 
* В результате получил виртуальную машину с дисками ssd1, ssd2.
# Задание 2 (Эмуляция отказа одного из дисков)
1. Удаление диска ssd1 в свойствах машины, проверка работоспособности виртуальной машины.
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_18_53_10.png)
2. Добавление в интерфейсе VM нового диска такого же размера с названием ssd5
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/screen1.JPG)
3. Выполнение операций:
* Просмотр нового диска, что он приехал в систему командой fdisk -l
* Копирование таблиц разделов со старого диска на новый: sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* Результат
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_22_53.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_18_53_10.png)
* Добавление в рейд массив нового диска: mdadm --manage /dev/md0 --add /dev/YYY
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_25_12.png)
* Результат cat /proc/mdstat
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_26_37.png)
4. Выполение синхронизации разделов, не входящих в RAID
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_26_54.png)
5. Установка grub на новый диск
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_27_40.png)
6. Перезагрузка ВМ и проверка, что все работает
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/2/VirtualBox_os_24_05_2019_19_29_26.png)
## Вывод
В этом задании научился:
* Удалять диск ssd1
* Проверять статус RAID-массива
* Копировать таблицу разделов со старого диска на новый
* Добавлять в рейд массив новый диск
* Выполнять синхронизацию разделов, не входящих в RAID

Изучил новые команды:
* sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* mdadm --manage /dev/md0 --add /dev/YYY

Результат: Удален диск ssd1, добавлен диск ssd3, ssd2 сохранили
# Задание 3 (Добавление новых дисков и перенос раздела)
1. Эмулирование отказа диска ssd2 и просмотр состояние дисков RAID
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_47_13.png)
2. Добавление нового ssd диска
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_50_36.png)
3. Перенос данных с помощью LVM
* Копирование файловую таблицу со старого диска на новый
* Копирование данных /boot на новый диск
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_53_12.png)
* Перемонтировака /boot на живой диск
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_55_26.png)
* Установка grub на новый диск
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_58_07.png)

Grub устанавливаем, чтобы могли загрузить ОС с этого диска
* Создание нового RAID-массива с включением туда только одного нового ssd диска:
* Проверка результата
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_19_58_49.png)

Появился /dev/md63

4. Настройка LVM
* Выполнение команды pvs для просмотра информации о текущих физических томах
* Создание нового физического тома, включив в него ранее созданный RAID массив:
* Выполнение команд lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT и pvs
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_00_17.png)


К md63 добавился FSTYPE - LVM2_member, так же dev/md63 добавился к результату команды pvs
* Увеличение размера Volume Group system
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_00_56.png)
* Выполнение команд
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
```
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_01_23.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_05_18.png)

LV var,log,root находятся на /dev/md0
* Перемещение данных со старого диска на новый
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_09_02.png)
* Выполнение команд:
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
```
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_09_29.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_11_11.png)
* Изменение VG, удалив из него диск старого raid.
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_11_53.png)
```
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
pvs
vgs
```
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_12_52.png)

В выводе команды pvs у /dev/md0 исчезли VG и Attr.
В выводе команды vgs #PV - уменьшилось на 1, VSize, VFree - стали меньше
* Перемонтировка /boot на второй диск, проверка, что boot не пустой
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_14_41.png)
5. Удаление ssd3 и добавление ssd,hdd1,hdd2

![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/screen1.JPG)

6. Восстановление работы основного RAID массива:
* Копирование таблицы разделов:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_23_04.png)
7. Копирование загрузочного раздела /boot с диска ssd4 на ssd5
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_25_28.png)
8. Установка grub на ssd5
9. Изменение размера второго раздела диска ssd5
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_26_51.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_27_30.png)
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_27_48.png)
10. Перечитывание таблицы разделов
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_30_40.png)
* Добавление нового диска к текущему raid массиву
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_31_21.png)
* Расширение количество дисков в массиве до 2-х штук:
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_32_18.png)
11. Увеличение размера раздела на диске ssd4
* Запуск утилиты для работы с разметкой дисков
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_33_55.png)
12. Перечитаем таблицу разделов
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_34_31.png)
13. Расширение размера raid
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_35_03.png)

Размер md127 стал 4.5G
* Вывод команды pvs
* Расширение размера PV
* Вывод команды pvs
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_36_29.png)
14. Добавление вновь появившееся место VG var,root
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_40_26.png)
15. Перемещение /var/log на новые диски
* Посмотрел какие имена имеют новые hhd диски
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_41_52.png)
* Создание RAID массива
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_42_58.png)
* Создание нового PV на рейде из больших дисков
* Создание в этом PV группу с названием data
* Создание логического тома с размером всего свободного пространства и присвоением ему имени var_log
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_49_25.png)
* Отформатирование созданного раздела в ext4
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_50_11.png)
16. Перенос данных логов со старого раздела на новый
* Примонтирование временно нового хранилище логов
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_51_55.png)
* Выполнение синхронизации разделов
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_52_20.png)
* Процессы работающие с /var/log
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_54_12.png)
* Остановка этих процессов
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_55_34.png)
* Выполнение финальной синхронизации разделов
* Поменял местами разделы
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_20_56_33.png)
17. Правка /etc/fstab
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_21_01_48.png)
18. Проверка всего
![alt-текст](https://github.com/D1103/Os/blob/master/laba2/3/VirtualBox_os_24_05_2019_21_06_46.png)














