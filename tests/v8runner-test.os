﻿#Использовать ".."
#Использовать asserts
#Использовать fs
#Использовать tempfiles

Перем юТест;
Перем УправлениеКонфигуратором;

Процедура Инициализация()
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
	Лог = Логирование.ПолучитьЛог("oscript.lib.v8runner");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("ТестДолжен_ИзменитьКаталогСборки");
	СписокТестов.Добавить("ТестДолжен_СоздатьВременнуюБазу");
	СписокТестов.Добавить("ТестДолжен_ПроверитьНазначениеПутиКПлатформе");
	СписокТестов.Добавить("ТестДолжен_ПроверитьУстановкуЯзыкаИнтерфейса");
	СписокТестов.Добавить("ТестДолжен_СоздатьХранилищеКонфигурации");
	СписокТестов.Добавить("ТестДолжен_ПроверитьСозданиеФайловПоставки");
    СписокТестов.Добавить("ТестДолжен_ПроверитьФормированиеФайлаОтчетПоВерсиямХранилища");
    СписокТестов.Добавить("ТестДолжен_СкопироватьПользователейИзХранилища");

	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ИзменитьКаталогСборки() Экспорт
	
	ПоУмолчанию = ТекущийКаталог();
	Утверждения.ПроверитьРавенство(УправлениеКонфигуратором.КаталогСборки(), ПоУмолчанию, "По умолчанию каталог сборки должен совпадать с текущим каталогом");
	
	СтароеЗначение = УправлениеКонфигуратором.КаталогСборки(КаталогВременныхФайлов());
	Утверждения.ПроверитьРавенство(СтароеЗначение, ПоУмолчанию, "Предыдущее значение каталога должно возвращяться при его смене");
	Утверждения.ПроверитьРавенство(УправлениеКонфигуратором.КаталогСборки(), КаталогВременныхФайлов(), "Каталог сборки должен быть изменен");
	
КонецПроцедуры

Процедура ТестДолжен_СоздатьВременнуюБазу() Экспорт
    
	Если УправлениеКонфигуратором.ВременнаяБазаСуществует() Тогда
		УдалитьФайлы(УправлениеКонфигуратором.ПутьКВременнойБазе());
	КонецЕсли;
	
	Утверждения.ПроверитьЛожь(УправлениеКонфигуратором.ВременнаяБазаСуществует(), "Временной базы не должно быть в каталоге <"+УправлениеКонфигуратором.ПутьКВременнойБазе()+">");
	УправлениеКонфигуратором.СоздатьФайловуюБазу(УправлениеКонфигуратором.ПутьКВременнойБазе());
	Сообщить(УправлениеКонфигуратором.ВыводКоманды());
	Утверждения.ПроверитьИстину(УправлениеКонфигуратором.ВременнаяБазаСуществует(), "Временная база должна существовать");
	УдалитьФайлы(УправлениеКонфигуратором.ПутьКВременнойБазе());
	
КонецПроцедуры


Процедура ТестДолжен_СоздатьХранилищеКонфигурации() Экспорт
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

	КаталогВременногоХранилища = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository");

	ФайлКонфигурации = ОбъединитьПути(ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures"), "1.0","1Cv8.cf");
		
	
	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
	// по идеи надо проверить что конфигурация загружена.
	// Вопрос как?
	УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
									КаталогВременногоХранилища,
									"Администратор");
	Утверждения.ПроверитьИстину(ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища), "Временное хранилище конфигурации должно существовать");
	ВременныеФайлы.Удалить() 
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьФормированиеФайлаОтчетПоВерсиямХранилища() Экспорт
    
    ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

    УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);
	ПутьКФайлуОтчета = ПолучитьИмяВременногоФайла("mxl");
    
	КаталогВременногоХранилища = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository");

    ФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0","1Cv8.cf");
        
    
    УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
    УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
                                    КаталогВременногоХранилища,
                                    "Администратор");
    Ожидаем.Что(ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища), "Временное хранилище конфигурации должно существовать");
    
    
    
    
    УправлениеКонфигуратором.ПолучитьОтчетПоВерсиямИзХранилища(КаталогВременногоХранилища, "Администратор", , ПутьКФайлуОтчета);
    
    ФайлОтчета = Новый Файл(ПутьКФайлуОтчета);

    Ожидаем.Что(ФайлОтчета.Существует(), "Отчет из хранилища конфигурации должен существовать");
        
    ВременныеФайлы.Удалить() 
    
КонецПроцедуры

Процедура ТестДолжен_ПроверитьСозданиеФайловПоставки() Экспорт
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

	КаталогПоставки = ОбъединитьПути(ВременныйКаталог, "v8r_TempDitr");
	
	ПутьФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0","1Cv8.cf");
	
	НомерВерсииВыпуска = "1.0";
	
	ПутьФайлПредыдущейПоставки =  ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "0.9", "1Cv8.cf"); 

	ПутьФайлПолнойПоставки = ОбъединитьПути(КаталогПоставки, НомерВерсииВыпуска +".cf");
	
	ПутьФайлаПоставкиОбноления = ОбъединитьПути(КаталогПоставки, НомерВерсииВыпуска+".cfu");
	
	МассивФайловПредыдущейПоставки = новый Массив;
	МассивФайловПредыдущейПоставки.Добавить(ПутьФайлПредыдущейПоставки);

	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ПутьФайлКонфигурации, Истина);
	
	УправлениеКонфигуратором.СоздатьФайлыПоставки(ПутьФайлПолнойПоставки,
												ПутьФайлаПоставкиОбноления,
												МассивФайловПредыдущейПоставки);
	
	Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьФайлПолнойПоставки), "Файл полной поставки конфигурации должен существовать");
	Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьФайлаПоставкиОбноления), "Файл частичной поставки конфигурации должен существовать");
	
	ВременныеФайлы.Удалить(); 
	
КонецПроцедуры




Процедура ТестДолжен_ПроверитьНазначениеПутиКПлатформе() Экспорт
	
	ПутьПоУмолчанию = УправлениеКонфигуратором.ПолучитьПутьКВерсииПлатформы("8.3");
	Утверждения.ПроверитьЛожь(ПустаяСтрока(ПутьПоУмолчанию));
	Утверждения.ПроверитьРавенство(ПутьПоУмолчанию, УправлениеКонфигуратором.ПутьКПлатформе1С());
	
	НовыйПуть = "тратата";
	Попытка
		УправлениеКонфигуратором.ПутьКПлатформе1С(НовыйПуть);
	Исключение
		Возврат;
	КонецПопытки;
	
	ВызватьИсключение "Не было выброшено исключение при попытке установить неверный путь";
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьУстановкуЯзыкаИнтерфейса() Экспорт
	
	ПоУмолчанию = "en";
	УправлениеКонфигуратором.УстановитьКодЯзыка(ПоУмолчанию);
	
	МассивПараметров = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	Утверждения.ПроверитьБольшеИлиРавно(МассивПараметров.Найти("/L"+ПоУмолчанию), 0, "Массив параметров запуска должен содержать локализацию  /L"+ПоУмолчанию + " строка:"+Строка(МассивПараметров));
	Утверждения.ПроверитьБольшеИлиРавно(МассивПараметров.Найти("/VL"+ПоУмолчанию), 0, "Массив запуска должен содержать локализацию сеанаса /VL"+ПоУмолчанию + " строка:"+Строка(МассивПараметров));
	
КонецПроцедуры

Процедура ТестДолжен_ДобавитьПользователяВХранилище() Экспорт
    
    ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
    УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

    КаталогВременногоХранилища = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository");

    ФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0", "1Cv8.cf");
        
    
    УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
    УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
                                    КаталогВременногоХранилища,
                                    "Администратор");
    Утверждения.ПроверитьИстину(ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища), "Временное хранилище конфигурации должно существовать");
    
    НовыйПользователь = "ТестовыйПользователь";
    ПарольПользователя = "ТестПароль";
    УправлениеКонфигуратором.ДобавитьПользователяВХранилище(КаталогВременногоХранилища, 
                                                            "Администратор",
                                                            ,
                                                            НовыйПользователь,
                                                            ПарольПользователя,
                                                            ПраваПользователяХранилища.ТолькоЧтение,
                                                            Истина);
    
    ПутьКФайлуВерсии = УправлениеКонфигуратором.ПолучитьВерсиюИзХранилища(КаталогВременногоХранилища, НовыйПользователь, ПарольПользователя);

    Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьКФайлуВерсии), "Файл конфигурации из хранилища должен существовать");
    
    ВременныеФайлы.Удалить() 
КонецПроцедуры


Процедура ТестДолжен_СкопироватьПользователейИзХранилища() Экспорт
    
    ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
    УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);

    КаталогВременногоХранилища = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository");

    ФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0", "1Cv8.cf");
        
    
    УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
    УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
                                    КаталогВременногоХранилища,
                                    "Администратор");
    Утверждения.ПроверитьИстину(ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища), "Временное хранилище конфигурации должно существовать");
    
    НовыйПользователь = "ТестовыйПользователь";
    ПарольПользователя = "123";
    УправлениеКонфигуратором.ДобавитьПользователяВХранилище(КаталогВременногоХранилища, 
                                                            "Администратор",
                                                            ,
                                                            НовыйПользователь,
                                                            ПарольПользователя,
                                                            ПраваПользователяХранилища.ТолькоЧтение,
                                                            Истина);
    
    ПутьКФайлуВерсии = УправлениеКонфигуратором.ПолучитьВерсиюИзХранилища(КаталогВременногоХранилища, НовыйПользователь, ПарольПользователя);
    
    Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьКФайлуВерсии), "Файл конфигурации из хранилища должен существовать");
    
    КаталогВременногоХранилища2 = ОбъединитьПути(ВременныйКаталог, "v8r_TempRepository2");

    ФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0","1Cv8.cf");
        
    
    УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации);
    УправлениеКонфигуратором.СоздатьФайловоеХранилищеКонфигурации(
                                    КаталогВременногоХранилища2,
                                    "Администратор2");
    Утверждения.ПроверитьИстину(ХранилищеКонфигурацииСуществует(КаталогВременногоХранилища2), "Временное хранилище 2 конфигурации должно существовать");
    
    УправлениеКонфигуратором.КопироватьПользователейИзХранилища(КаталогВременногоХранилища2, 
                                                            "Администратор2",
                                                            ,
                                                            КаталогВременногоХранилища,
                                                            "Администратор",
                                                            ,
                                                            Истина);
    
    ПутьКФайлуВерсии = УправлениеКонфигуратором.ПолучитьВерсиюИзХранилища(КаталогВременногоХранилища2, НовыйПользователь, ПарольПользователя);
    
    Утверждения.ПроверитьИстину(ФС.ФайлСуществует(ПутьКФайлуВерсии), "Файл конфигурации из хранилища должен существовать");
    
    ВременныеФайлы.Удалить() 
КонецПроцедуры

Функция ХранилищеКонфигурацииСуществует(Знач ПапкаХранилища)
	ФайлБазы = Новый Файл(ОбъединитьПути(ПапкаХранилища, "1cv8ddb.1CD"));
	
	Возврат ФайлБазы.Существует();
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация


Инициализация();
