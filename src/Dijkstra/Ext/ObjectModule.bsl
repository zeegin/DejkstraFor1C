//
// Реализация алгоритма Дейкстры на языке 1С
// Copyright (c) Ingvar Vilkman 2016
//

// a < b, при условии, что Undefined бесконечность.
//
// Параметры:
//    a - Число - первое число для сравнения.
//    b - Число - второе число для сравнения.
//
// Возвращаемое значение:
//    Булево - результат сравнения, при условии, что Undefined бесконечность.
//
Function JL(a, b)
	
	Return a <> Undefined And (b = Undefined Or a < b);
					
EndFunction

// Алгоритм Дейкстры.
//
// Параметры:
//    adj_matrix - Массив	- матрица смежности.
//    source	 - Число	- вершина источник.
//    target     - Число  	- вершина назначение.
//
// Возвращаемое значение:
//    Структура("Parent, Dist")	  - структура с данными для рассчета оптимальных расстоний от source до любой вершины.
//    Структура("Sequence, Dist") - последовательность вершин от source до target.
//    
//    Когда target = Неопредлено:
//       Возвращается структура с данными для рассчета оптимальных расстоний от source до любой вершины
//       
//       Структура("Parent, Dist"), где 
//          в Parent[i] - Массив - вершина, из которой лежит оптимальный путь в i.
//		    в Dist[i] 	- Массив - минимальное расстояние от source до i.
// 	  
//    Когда target указан:
//       Выполняется реверсивное восстановление последовательности вершин от source до target 
// 
//	     Структура("Sequence, Dist"), где	
//          в Sequence[i] - Массив - последовательность вершин, через которые проходит оптимальный путь.
//		    в Dist	 	  - Число  - кратчайший путь.
//
Function Dijkstra(adj_matrix, source, target = Undefined) Export
	 
	n = adj_matrix.UBound(); // Наибольший индекс в матрице. 
	
	in_tree	= New Array(n + 1); // Вершины, помеченные как "посещенные".
	dist	= New Array(n + 1); // Кратчайшие расстояние до вершины из источника, считаем Undefined бесконечностью.
	prev	= New Array(n + 1); // Последние промежуточные вершины на маршруте.
			
	For i = 0 To n Do	
		in_tree[i] = False;
	EndDo;

	//
	
	dist[source] = 0; // Расстояние до источника 0.
	
	current = source;
	
	While Not in_tree[current] Do
		
		in_tree[current] = True;
		
		For i = 0 To n Do
			
			// Если между current и i есть ребро.
			If adj_matrix[current][i] <> Undefined Then
				
				// Считаем расстояние до вершины i:
				// расстояние до current + вес ребра.
				d = dist[current] + adj_matrix[current][i];
				
				// Если оно меньше, чем уже записанное.				
				If JL(d, dist[i]) Then
					dist[i] = d; // Обновляем его
					prev[i] = current; // И "родителя"
				EndIf;
				
			EndIf;
			
		EndDo;
		
		// Ищем нерассмотренную вершину
		// с минимальным расстоянием.
		min_dist = Undefined; // Бесконечность
		For i = 0 To n Do
			
			If Not in_tree[i] And JL(dist[i], min_dist) Then
					
				current = i;
				min_dist = dist[i];	
				
			EndIf;
			
		EndDo;
		
	EndDo;
	
	// Теперь:
	//    в dist[i] минимальное расстояние от source до i.
	//    в prev[i] вершина, из которой лежит оптимальный путь в i.	
	If target = Undefined Then	
		Return New Structure("Parent, Dist", prev, dist);	
	EndIf;
	
	// reverse iteration
	
	// Кратчайший путь от source до target.
	seq = New Array;
	u = target;
		
	While prev[u] <> Undefined Do
		
		u = prev[u];
		seq.Insert(0, u); // Вставить в начало.
		
	EndDo;
	
	seq.Add(target); // Вставить в конец.
	
	Return New Structure("Sequence, Dist", seq, dist[target]); 
	
EndFunction

// Тест кейс
//
Procedure __ctor()
	
	C = New Array(5, 5); 	
	C[0][0] = Undefined;
	C[0][1] = 10;
	C[0][2] = 30;
	C[0][3] = 50;
	C[0][4] = 10;
	C[1][0] = Undefined;
	C[1][1] = Undefined;
	C[1][2] = Undefined;
	C[1][3] = Undefined;
	C[1][4] = Undefined;
	C[2][0] = 50;
	C[2][1] = Undefined;
	C[2][2] = Undefined;
	C[2][3] = Undefined;
	C[2][4] = 10;
	C[3][0] = Undefined;
	C[3][1] = Undefined;
	C[3][2] = 20;
	C[3][3] = Undefined;
	C[3][4] = Undefined;
	C[4][0] = 150;
	C[4][1] = Undefined;
	C[4][2] = 10;
	C[4][3] = 30;
	C[4][4] = Undefined;
	
	S = Dijkstra(C, 4);
	
	S = Dijkstra(C, 0, 3);
	
EndProcedure

// Запуск теста
__ctor();


