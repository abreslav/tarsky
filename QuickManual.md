# Установка #

Скачайте архив http://tarsky.googlecode.com/files/tarski_algorithm.zip

Распакуйте и запустите `AllTarsky.exe`

После окончания вычислений на экране появится окно с графиками полиномов и откроется HTML-страница с отчетом.

# Входные данные #

Утверждение для проверки истинности задается в файле inputFormula.txt.

Пример:
```
A x { [[x^4 + x^2 > 5] and [x3 - 4 > 25 * x]] --> [x > 0] }
```

Грамматика входного языка доступна [здесь](http://code.google.com/p/tarsky/source/browse/trunk/grammar).