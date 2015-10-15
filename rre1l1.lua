taylor_s = room {
	nam = 'Поселок Тейлор';
	dsc = [[
Вы в центральной части поселка Тейлор. 
На севере от вас широкая улица.
Неширокая улочка уходит на юг.
	]];
	way = {
		vroom('На запад', 'room2'),
		vroom('На север', 'room2'),
		vroom('На юг', 's_turn'),
		vroom('На восток', 'room2'),
	};
	obj = {
		'car';
	};
}

s_turn = room {
	nam = 'Поворот';
	dsc = [[
Вы в южной части поселка Тейлор.
Указатель показывает на восток "Трасса 71"
На север и на восток уходит неширокая дорога.
	]];
	way = {
		vroom('На запад', 'room2'),
		vroom('На север', 'taylor_s'),
		vroom('На юг', 'room3'),
		vroom('На восток', 'room2'),
	};
	obj = {
		'table', 'box';
	};
}

room2 = room {
  nam = 'Вторая комната';
	dsc = [[
Вторая комната
	]];
	obj = {
	  'car', 'door';
	};
	way = {
    's_turn';
		'street';
	};
  exit = function(s, w)
	  if w == street and door._locked then
			p 'Запертая дверь не дает вам выйти.';
			return false;
		end;
	end;
}

room3 = room {
  nam = 'Вторая комната';
	dsc = [[
Третья комната
	]];
	obj = {
	  'window';
	};
	way = {
    's_turn';
		'to_street';
	};
}

street = xroom {
  nam = "На улице";
	dsc = [[
Вы на улице.
	]];
	xdsc = [[
Та, часть описания, что не пропадет.
	]];
	way = {
	  'room2';
	};
  enter = function(s, w)
	  if w == room3 then
			p 'Вы спустились вниз, на улицу.';
		end;
	end;
  exit = function(s, w)
	  if w == room2 and door._locked then
			p 'Запертая дверь не дает вам войти.';
			return false;
		end;
	end;
}

to_street = vroom('вылезти в окно', 'street'):disable();
-------------------------------------------------------------------------------

car = obj {
  nam = 'пикап';
	dsc = [[
По улице едет старый красный {пикап}
	]];
}

table = obj {
	nam = 'стол';
	dsc = 'В комнате стоит {стол}.';
	act = 'Просто стол...';
}

box = obj {
	_empty = false;
	nam = 'шкатулка';
	dsc = 'На столе стоит {шкатулка}.';
	tak = 'Интересная штуковина';
	inv = function(s)
		if s._empty then
			p 'В шкатулке больше ничего нет.';
		else
			p 'Вы достали из шкатулки ключ.';
			take 'key';
			s._empty = true;
		end;
	end;
	use = function(s, w)
		if w == table then
		  drop(box);
			p 'Вы положили шкатулку обратно на стол';
		end;
  end;			
}

key = obj {
  nam = 'ключ';
	tak = 'Вы достали из шкатулки ключ';
	inv = 'Похож на ключ от двери.';
	use = function(s, w)
	  if w == door and door._locked then
		  door._locked = false;
			p 'Вы отперли дверь ключом.';
		elseif w == door then
			door._locked = true;
			p 'Вы заперли дверь ключом.';
		end;
	end;
}

door = obj {
  _locked = true;
	nam = 'дверь';
	dsc = [[
В этой комнате есть {дверь} на улицу.
	]];
	act = function(s)
	  if s._locked then
			p 'Дверь заперта.';
		else
			p 'Дверь не заперта.';
		end;
	end;
}

window = obj {
  _closed = true;
	nam = 'окно';
	dsc = [[
В этой комнате есть большое {окно}.	
	]];
	act = function(s)
	  if s._closed then
			s._closed = false;
			to_street:enable();
			p 'Вы открыли окно.';
		else
			s._closed = true;
			to_street:disable();
			p 'Вы закрыли окно.';
		end;
	end;
}
