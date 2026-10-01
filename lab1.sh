#!/bin/bash

set -e

cd ~/lab0

mkdir -p claude_monet/kitchen/morning_shift
mkdir -p claude_monet/kitchen/evening_shift
mkdir -p claude_monet/hall
mkdir -p claude_monet/office
mkdir -p staff_room
mkdir -p reserve_empty

cat > claude_monet/kitchen/morning_shift/senya_tasks <<'EOF'
Сеня принимает мясо в начале смены
До открытия нужно подготовить горячий цех
Лёва ждёт отчёт о продуктах
После обеда проверить остатки на складе
EOF

cat > claude_monet/kitchen/morning_shift/fedya_tasks <<'EOF'
Федя проверяет свежесть рыбы
Утром подготовить холодные закуски
Перед подачей показать блюдо Лёве
В конце смены убрать рабочее место
EOF

cat > claude_monet/kitchen/evening_shift/max_tasks <<'EOF'
Макс приходит на вечернюю смену
Первое блюдо готовится для седьмого столика
Баринов поручил Максу новый соус
После закрытия помочь Лёве с отчётом
EOF

cat > claude_monet/kitchen/evening_shift/denis_tasks <<'EOF'
Денис выступает перед гостями вечером
До концерта он помогает на кухне
В середине смены приготовить заказ Нагиева
Последнее блюдо передать официантам
EOF

cat > claude_monet/kitchen/leva_order <<'EOF'
Лёва распределяет задачи между поварами
Утренняя смена готовит ресторан к открытию
Вечерняя смена отвечает за банкет
Все отчёты передать Лёве после закрытия
EOF

cat > claude_monet/hall/table_plan <<'EOF'
Столик один обслуживает Настя
Столик три оставить для постоянных гостей
Столик семь принимает большой заказ
Банкетный стол подготовить к вечеру
EOF

cat > claude_monet/hall/complaints <<'EOF'
Гость долго ждал блюдо от Макса
За третьим столиком забыли принести напитки
Один заказ вернули на кухню
Вика просит разобрать жалобы после смены
EOF

cat > claude_monet/office/barinov_schedule <<'EOF'
Баринов приходит на кухню до открытия
В полдень шеф проверяет утреннюю смену
Перед банкетом проходит общее собрание
Лёва докладывает шефу после закрытия
EOF

cat > staff_room/late_report <<'EOF'
Сеня опоздал на утреннюю смену
Макс перепутал время собрания
Лёва записал объяснения поваров
Повторные опоздания передадут Баринову
EOF

cat > shift_message <<'EOF'
Команда собирается за час до открытия
Лёва назначен старшим на текущую смену
Вика проверяет готовность зала
Баринов ждёт общий отчёт утром
EOF


chmod 755 claude_monet
chmod 750 claude_monet/kitchen/morning_shift
chmod 640 claude_monet/kitchen/morning_shift/fedya_tasks
chmod 644 claude_monet/kitchen/evening_shift/max_tasks
chmod 660 claude_monet/kitchen/leva_order
chmod 644 claude_monet/hall/table_plan
chmod 750 claude_monet/office
chmod 640 staff_room/late_report
chmod 700 reserve_empty
chmod 644 shift_message

chmod u=rwx,g=rx,o= claude_monet/kitchen
chmod u=rw,g=r,o= claude_monet/kitchen/morning_shift/senya_tasks
chmod u=rwx,g=rx,o= claude_monet/kitchen/evening_shift
chmod u=rw,g=r,o=r claude_monet/kitchen/evening_shift/denis_tasks
chmod u=rwx,g=rx,o=rx claude_monet/hall
chmod u=rw,g=rw,o=r claude_monet/hall/complaints
chmod u=rw,g=r,o= claude_monet/office/barinov_schedule
chmod u=rwx,g=rx,o= staff_room

cp staff_room/late_report \
   claude_monet/office/discipline_report

cp -r claude_monet/kitchen/morning_shift \
      claude_monet/kitchen/evening_shift/morning_backup

ln -s ../claude_monet/kitchen/leva_order \
      staff_room/current_order

ln -s claude_monet/kitchen \
      shift_kitchen

ln shift_message \
   claude_monet/kitchen/common_message

cat claude_monet/kitchen/morning_shift/senya_tasks \
    claude_monet/kitchen/morning_shift/fedya_tasks \
    > claude_monet/kitchen/morning_report

cat claude_monet/office/barinov_schedule \
    >> claude_monet/kitchen/leva_order

mv claude_monet/hall/complaints \
   claude_monet/office/guest_complaints

echo "1. Первые пять обычных файлов, отсортированных по размеру:"

ls -lR |
grep '^-' |
sort -k5,5nr |
head -n 5


echo "2. Строки со словами 'смен' или 'лёва', без 'отчёт':"

grep -RihE 'смен|лёва' claude_monet |
grep -iv 'отчёт' |
sort |
head -n 6


echo "3. Количество файлов, содержащих 'смен':"

grep -il 'смен' \
    claude_monet/kitchen/morning_shift/* \
    claude_monet/kitchen/evening_shift/morning_backup/* |
wc -l


echo "4. Последние две строки файлов *_tasks, содержащие 'лёва' или 'смен':"

tail -q -n 2 \
    claude_monet/kitchen/morning_shift/*_tasks \
    claude_monet/kitchen/evening_shift/*_tasks |
grep -Ei 'лёва|смен' |
sort -r


echo "5. Количество слов после фильтрации morning_report:"

grep -Ev 'Сеня|Федя' \
    claude_monet/kitchen/morning_report |
sort -r |
head -n 4 |
wc -w


echo "6. Обычные файлы с количеством жёстких ссылок 2:"

ls -lR |
grep '^-.* 2 ' |
sort -k9


echo "7. Символические ссылки без слова 'shift' в имени:"

ls -lR |
grep '^l' |
grep -v 'shift' |
sort -k9 -r

rm staff_room/late_report

rm staff_room/current_order

rm shift_kitchen

rm shift_message

rm claude_monet/kitchen/common_message

rm claude_monet/kitchen/evening_shift/denis_tasks

rmdir reserve_empty

rmdir claude_monet/kitchen/evening_shift/morning_backup 2>/dev/null || true

rm -r claude_monet/kitchen/evening_shift/morning_backup

