% Define numbers 1-4
num(1). num(2). num(3). num(4).

% Main planning predicate
plan(InitialState, SolvedState, Plan) :-
    % Copy InitialState to work on it
    copy_term(InitialState, CurrentState),
    % Generate the plan by filling empty cells
    plan_step(CurrentState, SolvedState, [], Plan).

% Base case: finish only when the state is solved (no zeros)
plan_step(State, State, Plan, Plan) :-
    solved(State).

% Recursive case: find an empty cell, fill it, and continue.
plan_step(CurrentState, SolvedState, PartialPlan, Plan) :-
    % Find an empty cell (0) at (Row, Col)
    nth1(Row, CurrentState, RowList),
    nth1(Col, RowList, 0),
    % Try filling it with Num (1-4)
    num(Num),
    % Check if Num is valid (no conflicts)
    is_valid(CurrentState, Row, Col, Num),
    % Fill the cell
    fill_cell(CurrentState, Row, Col, Num, NewState),
    % Record the action
    Action = fill(Row, Col, Num),
    % Continue planning
    plan_step(NewState, SolvedState, [Action | PartialPlan], Plan).

% Check if Num can be placed at (Row, Col) without conflicts
is_valid(State, Row, Col, Num) :-
    % Check Row
    nth1(Row, State, RowList),
    \+ member(Num, RowList),
    % Check Column
    column(State, Col, ColumnList),
    \+ member(Num, ColumnList),
    % Check 2x2 sub-square
    subgrid(State, Row, Col, Subgrid),
    \+ member(Num, Subgrid).

% Extract a column from the grid
column([], _, []).
column([Row|Rest], Col, [Value|Values]) :-
    nth1(Col, Row, Value),
    column(Rest, Col, Values).

% Extract the 2x2 subgrid containing (Row, Col)
% Extract the 2x2 subgrid containing (Row, Col)
subgrid(State, Row, Col, Subgrid) :-
    % Determine top-left corner of the subgrid
    SubRow is ((Row - 1) // 2) * 2 + 1,
    SubCol is ((Col - 1) // 2) * 2 + 1,
    % Calcular índices para a segunda linha e a segunda coluna do subgrid
    RowNext is SubRow + 1,
    ColNext is SubCol + 1,
    % Extract 4 cells
    nth1(SubRow, State, Row1),
    nth1(RowNext, State, Row2),
    nth1(SubCol, Row1, A),
    nth1(ColNext, Row1, B),
    nth1(SubCol, Row2, C),
    nth1(ColNext, Row2, D),
    Subgrid = [A, B, C, D].


% Fill cell (Row, Col) with Num
fill_cell(State, Row, Col, Num, NewState) :-
    nth1(Row, State, RowList),
    replace(RowList, Col, Num, NewRowList),
    replace(State, Row, NewRowList, NewState).

% Helper: Replace element at position in a list
replace([_|T], 1, X, [X|T]).
replace([H|T], Pos, X, [H|NewT]) :-
    Pos > 1,
    NextPos is Pos - 1,
    replace(T, NextPos, X, NewT).

% Check if the state is solved (no zeros in any row)
solved([]).
solved([Row|Rest]) :-
    \+ member(0, Row),
    solved(Rest).
