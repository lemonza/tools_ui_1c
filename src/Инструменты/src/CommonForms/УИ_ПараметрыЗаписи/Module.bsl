#Область ОписаниеПеременных

&НаКлиенте
Перем мПоследнийUUID;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УИ_ОбщегоНазначенияКлиентСервер.УстановитьПараметрыЗаписиНаФорму(ЭтотОбъект, Параметры.ПараметрыЗаписи, "");
	
	УИ_РедакторКодаСервер.ФормаПриСозданииНаСервере(ЭтотОбъект);
	УИ_РедакторКодаСервер.СоздатьЭлементыРедактораКода(ЭтотОбъект, "Редактор", Элементы.ПолеАлгоритмаПередЗаписью);
	
	Если Параметры.Свойство("ТипОбъекта") Тогда
		ТипОбъекта = Параметры.ТипОбъекта;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УИ_РедакторКодаКлиент.ФормаПриОткрытии(ЭтотОбъект, Новый ОписаниеОповещения("ПриОткрытииЗавершение",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	ПроцедураПередЗаписью = УИ_РедакторКодаКлиент.ТекстКодаРедактора(ЭтотОбъект, "Редактор");
	Закрыть(УИ_ОбщегоНазначенияКлиентСервер.ПараметрыЗаписиФормы(ЭтотОбъект, ""));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьУникальныйИдентификатор(Команда)
	ТекДанные = Элементы.ДополнительныеСвойства.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДопПараметрыОповещения=Новый Структура;
	ДопПараметрыОповещения.Вставить("ТекущаяСтрока", Элементы.ДополнительныеСвойства.ТекущаяСтрока);

	ПоказатьВводСтроки(Новый ОписаниеОповещения("ОбработатьВводУникальногоИдентификатора", ЭтаФорма,
		ДопПараметрыОповещения), мПоследнийUUID, "Введите уникальный идентификатор", , Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВводУникальногоИдентификатора(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;

	Попытка
		пЗначение = Новый УникальныйИдентификатор(Результат);
		мПоследнийUUID = Результат;
	Исключение
		ПоказатьПредупреждение( , "Значение не может быть преобразовано в Уникальный идентификатор!", 20);
		Возврат;
	КонецПопытки;

	ТекДанные = ДополнительныеПараметры.НайтиПоИдентификатору(ДополнительныеПараметры.ТекущаяСтрока);
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.Значение = пЗначение;
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПолеРедактораДокументСформирован(Элемент)
	УИ_РедакторКодаКлиент.ПолеРедактораHTMLДокументСформирован(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПолеРедактораПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	УИ_РедакторКодаКлиент.ПолеРедактораHTMLПриНажатии(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте 
Процедура Подключаемый_РедакторКодаЗавершениеИнициализации() Экспорт
	УИ_РедакторКодаКлиент.УстановитьТекстРедактора(ЭтотОбъект, "Редактор", ПроцедураПередЗаписью);
	
	Если ТипОбъекта <> Новый ОписаниеТипов Тогда
		ДобавляемыйКонтекст = Новый Структура;
		ДобавляемыйКонтекст.Вставить("Объект", ТипОбъекта.Типы()[0]);
			
		УИ_РедакторКодаКлиент.ДобавитьКонтекстРедактораКода(ЭтотОбъект, "Редактор", ДобавляемыйКонтекст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти




