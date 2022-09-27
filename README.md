```
Systemd

Описание/Пошаговая инструкция выполнения домашнего задания:
Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.
4*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.
```

* Клонируем проект: `git clone https://github.com/mmmex/systemd.git`

* Запускаем ВМ: `vagrant up`

Все необходимое будет выполнено автоматически скриптами:

[1. Скрипт настройки сервиса мониторинга лога](01init_service.sh)

[2. Скрипт который выполнит настройку spawn-fcgi unit systemd](02init_fcgi.sh)

[3. Скрипт подготовит два сервиса httpd@first и httpd@second](03change_httpd.sh)

### Сервис мониторинга лога watchlog

После запуска ВМ заходим от суперпользователя root: `vagrant ssh`, `sudo -i`. Далее для проверки 1ой части задания нужно выполнить:

1. Проверяем статус сервиса: `systemctl status watchlog.timer`

```shell
[root@localhost ~]# systemctl status watchlog.timer 
● watchlog.timer - Run watchlog script every 30 second
   Loaded: loaded (/etc/systemd/system/watchlog.timer; disabled; vendor preset: disabled)
   Active: active (waiting) since Tue 2022-09-27 00:13:55 UTC; 19min ago

Sep 27 00:13:55 localhost.localdomain systemd[1]: Started Run watchlog script every 30 second.
```

2. Выполним команду `logger ALERT`, которая запишет ключевое слово `ALERT` в лог `/var/log/messages`

3. Открываем лог `/var/log/messages` и видим через каждые 30 секунд сообщения `I found word, Master!`: `tail -f /var/log/messages`

```shell
[root@localhost ~]# tail -f /var/log/messages
Sep 27 10:44:24 localhost systemd: Removed slice User Slice of vagrant.
Sep 27 10:44:41 localhost systemd: Starting My watchlog service...
Sep 27 10:44:41 localhost systemd: Started My watchlog service.
Sep 27 10:44:44 localhost systemd: Created slice User Slice of vagrant.
Sep 27 10:44:44 localhost systemd: Started Session 4 of user vagrant.
Sep 27 10:44:44 localhost systemd-logind: New session 4 of user vagrant.
Sep 27 10:45:10 localhost vagrant: ALERT
Sep 27 10:45:11 localhost systemd: Starting My watchlog service...
Sep 27 10:45:11 localhost root: Tue Sep 27 10:45:11 UTC 2022: I found word, Master!
Sep 27 10:45:11 localhost systemd: Started My watchlog service.
Sep 27 10:45:41 localhost systemd: Starting My watchlog service...
Sep 27 10:45:41 localhost root: Tue Sep 27 10:45:41 UTC 2022: I found word, Master!
Sep 27 10:45:41 localhost systemd: Started My watchlog service.
```

4. Останавливаем сервис: `systemctl stop watchlog.timer`

### Проверка работы unit сервиса для spawn-fcgi

1. Проверяем состояние сервиса: `systemctl status spawn-fcgi`

```shell
[root@localhost ~]# systemctl status spawn-fcgi         
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-09-27 00:14:41 UTC; 33min ago
 Main PID: 2604 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─2604 /usr/bin/php-cgi
           ├─2605 /usr/bin/php-cgi
           ├─2606 /usr/bin/php-cgi
           ├─2607 /usr/bin/php-cgi
           ├─2608 /usr/bin/php-cgi
           ├─2609 /usr/bin/php-cgi
           ├─2610 /usr/bin/php-cgi
           ├─2611 /usr/bin/php-cgi
           ├─2612 /usr/bin/php-cgi
           ├─2613 /usr/bin/php-cgi
           ├─2614 /usr/bin/php-cgi
           ├─2615 /usr/bin/php-cgi
           ├─2616 /usr/bin/php-cgi
           ├─2617 /usr/bin/php-cgi
           ├─2618 /usr/bin/php-cgi
           ├─2619 /usr/bin/php-cgi
           ├─2620 /usr/bin/php-cgi
           ├─2621 /usr/bin/php-cgi
           ├─2622 /usr/bin/php-cgi
           ├─2623 /usr/bin/php-cgi
           ├─2624 /usr/bin/php-cgi
           ├─2625 /usr/bin/php-cgi
           ├─2626 /usr/bin/php-cgi
           ├─2627 /usr/bin/php-cgi
           ├─2628 /usr/bin/php-cgi
           ├─2629 /usr/bin/php-cgi
           ├─2630 /usr/bin/php-cgi
           ├─2631 /usr/bin/php-cgi
           ├─2632 /usr/bin/php-cgi
           ├─2633 /usr/bin/php-cgi
           ├─2634 /usr/bin/php-cgi
           ├─2635 /usr/bin/php-cgi
           └─2636 /usr/bin/php-cgi

Sep 27 00:14:41 localhost.localdomain systemd[1]: Started Spawn-fcgi startup service by Otus.
```

2. Останавливаем сервис: `systemctl stop spawn-fcgi`

### Проверка сервисов httpd@first и httpd@second

1. Для проверки `httpd@first` выполним команду: `systemctl status httpd@first`

```shell
[root@localhost ~]# systemctl status httpd@first
● httpd@first.service - The Apache HTTP Server first
   Loaded: loaded (/usr/lib/systemd/system/httpd@.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-09-27 00:14:42 UTC; 37min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2766 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@first.service
           ├─2766 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─2767 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─2768 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─2769 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─2770 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─2771 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           └─2772 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND

Sep 27 00:14:42 localhost.localdomain systemd[1]: Starting The Apache HTTP Server first...
Sep 27 00:14:42 localhost.localdomain systemd[1]: Started The Apache HTTP Server first.
```

1. Для проверки `httpd@second` выполним команду: `systemctl status httpd@second`

```shell
[root@localhost ~]# systemctl status httpd@second
● httpd@second.service - The Apache HTTP Server second
   Loaded: loaded (/usr/lib/systemd/system/httpd@.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-09-27 00:14:42 UTC; 38min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2774 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@second.service
           ├─2774 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─2775 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─2776 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─2777 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─2778 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─2779 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           └─2780 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND

Sep 27 00:14:42 localhost.localdomain systemd[1]: Starting The Apache HTTP Server second...
Sep 27 00:14:42 localhost.localdomain systemd[1]: Started The Apache HTTP Server second.
```

Проверим открытые порты сервисом `httpd`:

```shell
[root@localhost ~]# ss -tunlp | grep httpd
tcp    LISTEN     0      128    [::]:8080               [::]:*                   users:(("httpd",pid=2772,fd=4),("httpd",pid=2771,fd=4),("httpd",pid=2770,fd=4),("httpd",pid=2769,fd=4),("httpd",pid=2768,fd=4),("httpd",pid=2767,fd=4),("httpd",pid=2766,fd=4))
tcp    LISTEN     0      128    [::]:8081               [::]:*                   users:(("httpd",pid=2780,fd=4),("httpd",pid=2779,fd=4),("httpd",pid=2778,fd=4),("httpd",pid=2777,fd=4),("httpd",pid=2776,fd=4),("httpd",pid=2775,fd=4),("httpd",pid=2774,fd=4))
```

Основное задание выполнено.