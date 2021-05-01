&НаКлиенте
Перем мТипХЗ;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеХЗ = Параметры.ДанныеХЗ;

	Если ТипЗнч(ДанныеХЗ) = Тип("Строка") Тогда
		Если ЭтоАдресВременногоХранилища(ДанныеХЗ) Тогда
			ДанныеХЗ = ПолучитьИзВременногоХранилища(ДанныеХЗ);
		Иначе
			Попытка
				ДанныеХЗ=УИ_ОбщегоНазначенияВызовСервера.ЗначениеИзСтрокиXML(ДанныеХЗ);
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Если ТипЗнч(ДанныеХЗ) = Тип("ТабличныйДокумент") Тогда
		_ДанныеДляОтображения = Новый Структура("Значение, ТипЗначения", ДанныеХЗ, "ТабличныйДокумент");
		Возврат;
	ИначеЕсли ТипЗнч(ДанныеХЗ) = Тип("ТекстовыйДокумент") Тогда
		_ДанныеДляОтображения = Новый Структура("Значение, ТипЗначения", ДанныеХЗ, "ТекстовыйДокумент");
		Возврат;
	ИначеЕсли ТипЗнч(ДанныеХЗ) <> Тип("ХранилищеЗначения") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ДанныеХЗ = ДанныеХЗ.Получить();
	Если ДанныеХЗ = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ТипДанныхХЗ = ТипЗнч(ДанныеХЗ);

	Если ТипДанныхХЗ = Тип("Массив") Тогда
		Заголовок = "Массив";
		Отказ = Не вПоказатьМассив(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("Структура") Тогда
		Заголовок = "Структура";
		Отказ = Не вПоказатьСтруктуру(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("Соответствие") Тогда
		Заголовок = "Соответствие";
		Отказ = Не вПоказатьСоответствие(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("СписокЗначений") Тогда
		Заголовок = "СписокЗначений";
		Отказ = Не вПоказатьСписокЗначений(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("ТаблицаЗначений") Тогда
		Заголовок = "ТаблицаЗначений";
		Отказ = Не вПоказатьТаблицуЗначений(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("ДеревоЗначений") Тогда
		Заголовок = "ДеревоЗначений";
		Элементы._ТаблицаЗначений.Видимость = Ложь;
		Элементы._ДеревоЗначений.Видимость = Истина;
		Отказ = Не вПоказатьДеревоЗначений(ДанныеХЗ);
	ИначеЕсли ТипДанныхХЗ = Тип("ТабличныйДокумент") Тогда
		_ДанныеДляОтображения = Новый Структура("Значение, ТипЗначения", ДанныеХЗ, "ТабличныйДокумент");
	ИначеЕсли ТипДанныхХЗ = Тип("ТекстовыйДокумент") Тогда
		_ДанныеДляОтображения = Новый Структура("Значение, ТипЗначения", ДанныеХЗ, "ТекстовыйДокумент");
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мТипХЗ = Тип("ХранилищеЗначения");

	Если _ДанныеДляОтображения <> Неопределено Тогда
		Если _ДанныеДляОтображения.ТипЗначения = "ТабличныйДокумент" Тогда
			_ДанныеДляОтображения.Значение.Показать(_ДанныеДляОтображения.ТипЗначения);
		ИначеЕсли _ДанныеДляОтображения.ТипЗначения = "ТекстовыйДокумент" Тогда
			_ДанныеДляОтображения.Значение.Показать(_ДанныеДляОтображения.ТипЗначения);
		КонецЕсли;

		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция вПоказатьМассив(ДанныеХЗ)
	Если ДанныеХЗ.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Индекс", Новый ОписаниеТипов("Число"), "_ТаблицаЗначений",
		"Индекс", Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Значение", Новый ОписаниеТипов, "_ТаблицаЗначений", "Значение",
		Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("ТипЗначения", Новый ОписаниеТипов("Строка"), "_ТаблицаЗначений",
		"ТипЗначения", Ложь));

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	Для Инд = 0 По ДанныеХЗ.ВГраница() Цикл
		Значение = ДанныеХЗ[Инд];
		НС = _ТаблицаЗначений.Добавить();

		НС.Индекс = Инд;
		НС.ТипЗначения = Строка(ТипЗнч(Значение));

		Если вНадоПреобразоватьЗначение(Значение) Тогда
			НС.Значение = Новый ХранилищеЗначения(Значение);
		Иначе
			НС.Значение = Значение;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ТаблицаЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ТаблицаЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ТаблицаЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вПоказатьСтруктуру(ДанныеХЗ)
	Если ДанныеХЗ.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Ключ", Новый ОписаниеТипов("Строка"), "_ТаблицаЗначений",
		"Ключ", Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Значение", Новый ОписаниеТипов, "_ТаблицаЗначений", "Значение",
		Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("ТипЗначения", Новый ОписаниеТипов("Строка"), "_ТаблицаЗначений",
		"ТипЗначения", Ложь));

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	Для Каждого Элем Из ДанныеХЗ Цикл
		НС = _ТаблицаЗначений.Добавить();

		ЗаполнитьЗначенияСвойств(НС, Элем, , "Значение");
		НС.ТипЗначения = Строка(ТипЗнч(Элем.Значение));

		Если вНадоПреобразоватьЗначение(Элем.Значение) Тогда
			НС.Значение = Новый ХранилищеЗначения(Элем.Значение);
		Иначе
			НС.Значение = Элем.Значение;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ТаблицаЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ТаблицаЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ТаблицаЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вПоказатьСоответствие(ДанныеХЗ)
	Если ДанныеХЗ.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Ключ", Новый ОписаниеТипов, "_ТаблицаЗначений", "Ключ", Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Значение", Новый ОписаниеТипов, "_ТаблицаЗначений", "Значение",
		Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("ТипЗначения", Новый ОписаниеТипов("Строка"), "_ТаблицаЗначений",
		"ТипЗначения", Ложь));

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	Для Каждого Элем Из ДанныеХЗ Цикл
		НС = _ТаблицаЗначений.Добавить();

		ЗаполнитьЗначенияСвойств(НС, Элем, , "Значение");
		НС.ТипЗначения = Строка(ТипЗнч(Элем.Значение));

		Если вНадоПреобразоватьЗначение(Элем.Значение) Тогда
			НС.Значение = Новый ХранилищеЗначения(Элем.Значение);
		Иначе
			НС.Значение = Элем.Значение;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ТаблицаЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ТаблицаЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ТаблицаЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вПоказатьСписокЗначений(ДанныеХЗ)
	Если ДанныеХЗ.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Пометка", Новый ОписаниеТипов("Булево"), "_ТаблицаЗначений",
		"Пометка", Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Представление", Новый ОписаниеТипов("Строка"),
		"_ТаблицаЗначений", "Представление", Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("Значение", Новый ОписаниеТипов, "_ТаблицаЗначений", "Значение",
		Ложь));
	РеквизитыКДобавлению.Добавить(Новый РеквизитФормы("ТипЗначения", Новый ОписаниеТипов("Строка"), "_ТаблицаЗначений",
		"ТипЗначения", Ложь));

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	Для Каждого Элем Из ДанныеХЗ Цикл
		НС = _ТаблицаЗначений.Добавить();

		ЗаполнитьЗначенияСвойств(НС, Элем, , "Значение");
		НС.ТипЗначения = Строка(ТипЗнч(Элем.Значение));

		Если вНадоПреобразоватьЗначение(Элем.Значение) Тогда
			НС.Значение = Новый ХранилищеЗначения(Элем.Значение);
		Иначе
			НС.Значение = Элем.Значение;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ТаблицаЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ТаблицаЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ТаблицаЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вПоказатьТаблицуЗначений(ДанныеХЗ)
	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	Для Каждого Колонка Из ДанныеХЗ.Колонки Цикл
		РеквизитыКДобавлению.Добавить(Новый РеквизитФормы(Колонка.Имя, Новый ОписаниеТипов, "_ТаблицаЗначений",
			Колонка.Заголовок, Ложь));
	КонецЦикла;

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	Для Каждого Элем Из ДанныеХЗ Цикл
		НС = _ТаблицаЗначений.Добавить();

		Для Каждого Колонка Из ДанныеХЗ.Колонки Цикл
			Значение = Элем[Колонка.Имя];

			Если вНадоПреобразоватьЗначение(Значение) Тогда
				Значение = Новый ХранилищеЗначения(Значение);
			КонецЕсли;
			НС[Колонка.Имя] = Значение;
		КонецЦикла;
	КонецЦикла;

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ТаблицаЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ТаблицаЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ТаблицаЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вПоказатьДеревоЗначений(ДанныеХЗ)
	РеквизитыКДобавлению = Новый Массив;
	РеквизитыКУдалению = Новый Массив;

	Для Каждого Колонка Из ДанныеХЗ.Колонки Цикл
		РеквизитыКДобавлению.Добавить(Новый РеквизитФормы(Колонка.Имя, Новый ОписаниеТипов, "_ДеревоЗначений",
			Колонка.Заголовок, Ложь));
	КонецЦикла;

	ИзменитьРеквизиты(РеквизитыКДобавлению, РеквизитыКУдалению);

	вЗаполнитьУзелДЗ(_ДеревоЗначений, ДанныеХЗ, ДанныеХЗ.Колонки);

	Для Каждого Элем Из РеквизитыКДобавлению Цикл
		ИмяЭФ = "_ДеревоЗначений_" + Элем.Имя;
		ЭтаФорма.Элементы.Добавить(ИмяЭФ, Тип("ПолеФормы"), ЭтаФорма.Элементы._ДеревоЗначений);
		ЭтаФорма.Элементы[ИмяЭФ].ПутьКДанным = "_ДеревоЗначений." + Элем.Имя;
		ЭтаФорма.Элементы[ИмяЭФ].Вид = ВидПоляФормы.ПолеВвода;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция вЗаполнитьУзелДЗ(Знач Приемник, Знач Источник, Знач КоллекцияКолонок)
	Для Каждого Элем Из Источник.Строки Цикл
		НС = Приемник.ПолучитьЭлементы().Добавить();

		Для Каждого Колонка Из КоллекцияКолонок Цикл
			Значение = Элем[Колонка.Имя];

			Если вНадоПреобразоватьЗначение(Значение) Тогда
				Значение = Новый ХранилищеЗначения(Значение);
			КонецЕсли;
			НС[Колонка.Имя] = Значение;
		КонецЦикла;

		вЗаполнитьУзелДЗ(НС, Элем, КоллекцияКолонок);
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ОткрытьОбъект(Команда)
	Значение = Неопределено;

	Имя = вПолучитьПутьКДаннымТекущегоЭлемента();
	Если Не ЗначениеЗаполнено(Имя) Тогда
		Возврат;
	КонецЕсли;

	ЭФ = ЭтаФорма.ТекущийЭлемент;
	Если ТипЗнч(ЭФ) = Тип("ПолеФормы") Тогда
		Значение = ЭтаФорма[Имя];
	ИначеЕсли ТипЗнч(ЭФ) = Тип("ТаблицаФормы") Тогда
		ТекДанные = ЭФ.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			Значение = ТекДанные[Имя];
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(Значение) Тогда
		Если ТипЗнч(Значение) = мТипХЗ Тогда
			вПоказатьЗначениеХЗ(Значение);

		ИначеЕсли вЭтоОбъектМетаданных(ТипЗнч(Значение)) Тогда
			СтрукПарам = Новый Структура("мОбъектСсылка", Значение);
			ОткрытьФорму("Обработка.УИ_РедакторРеквизитовОбъекта.Форма.ФормаОбъекта", СтрукПарам, , Значение);

		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура вПоказатьЗначениеХЗ(Значение)
	СтрукПарам = Новый Структура("ДанныеХЗ", Значение);
	ОткрытьФорму("ОбщаяФорма.УИ_ФормаХранилищаЗначения", СтрукПарам, , ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура _ТаблицаЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяКолонки = Сред(Поле.Имя, СтрДлина(Элемент.Имя) + 2);
		Значение = ТекДанные[ИмяКолонки];

		Если ТипЗнч(Значение) = мТипХЗ Тогда
			вПоказатьЗначениеХЗ(Значение);
		Иначе
			ПоказатьЗначение( , Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ИмяКолонки = Сред(Поле.Имя, СтрДлина(Элемент.Имя) + 2);
		Значение = ТекДанные[ИмяКолонки];

		Если ТипЗнч(Значение) = мТипХЗ Тогда
			вПоказатьЗначениеХЗ(Значение);
		Иначе
			ПоказатьЗначение( , Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция вПолучитьПутьКДаннымТекущегоЭлемента()
	ЭФ = ЭтаФорма.ТекущийЭлемент;
	Если ТипЗнч(ЭФ) = Тип("ТаблицаФормы") Тогда
		ТекПоле = ЭФ.ТекущийЭлемент;
		Если ТипЗнч(ТекПоле) = Тип("ПолеФормы") Тогда
			Значение = ТекПоле.ПутьКДанным;
			Поз = Найти(Значение, ".");
			Если Поз <> 0 Тогда
				Значение = Сред(Значение, Поз + 1);
				Если Найти(Значение, ".") = 0 Тогда
					Возврат Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЭФ) = Тип("ПолеФормы") Тогда
		Возврат ЭФ.ПутьКДанным;
	КонецЕсли;

	Возврат "";
КонецФункции

&НаСервереБезКонтекста
Функция вЭтоОбъектМетаданных(Знач Тип)
	ОбъектМД = Метаданные.НайтиПоТипу(Тип);
	Возврат (ОбъектМД <> Неопределено И Не Метаданные.Перечисления.Содержит(ОбъектМД));
КонецФункции

&НаСервереБезКонтекста
Функция вЭтоПростойТип(Знач Тип)
	Результат = Тип = Тип("Число") Или Тип = Тип("Строка") Или Тип = Тип("Булево") Или Тип = Тип("Дата");

	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция вНадоПреобразоватьЗначение(Знач Значение)
	Если Значение = Неопределено Или Значение = Null Тогда
		Возврат Ложь;
	КонецЕсли;

	ТипЗначения = ТипЗнч(Значение);

	Если вЭтоПростойТип(ТипЗначения) Тогда
		Возврат Ложь;
	КонецЕсли;

	Если вЭтоОбъектМетаданных(ТипЗначения) Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат (ТипЗначения <> Тип("ХранилищеЗначения"));
КонецФункции