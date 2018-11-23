
graduated(Transcript, Unused) :-
    complete(Transcript, _, _, _).

%% try complete([cpsc110, cpsc121, cpsc200, cpsc310, math100, math101, cpsc210, cpsc213, cpsc221, math200, math221], CS, _, _).
complete(Transcript, CSDegreeRequirements, ArtsRequirements, Misc):-
    cs_requirements(Transcript, Result),
    check_difference(Transcript, CSDegreeRequirements, Result).
%% add arts and misc here


%%                  CS REQUIREMENTS
%% --------------------------------------------------------------------------------
cs_requirements(Transcript, Result):-
    first_year_cs_requirements(Transcript, R1),
    second_year_cs_requirements(R1, Result).
%%    thirdfourth_year_cs_requirements(R2, Result). 

first_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc110, cpsc121], R1),
    first_year_math1(R1, R2),
    first_year_math2(R2, Result).

second_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc210, cpsc213, cpsc221], R1),
    second_year_math(R1, R2),
    second_year_math(R2, Result).

/*
thirdfourth_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc310, cpsc313, cpsc320], R1),
    threehunnid_level_CPSC(R1, ToBeRemoved),
    proper_length(ToBeRemoved, X),
    X>1,
    take(2, ToBeRemoved, Firsttwo),
    subtract(Transcript, Firsttwo, Result).

threehunnid_level_CPSC([H|R], ToBeRemoved) :-
    prop(H, number, CourseNumber),
    CourseNumber >= 300,
    CourseNumber < 400,
    append(, [H], ToBeRemoved),
    threehunnid_level_CPSC(R, ToBeRemoved).
*/

%%                  HELPER FUNCTIONS
%% -----------------------------------------------------------------------------------
remove_from_transcript(Transcript, [], Transcript).
remove_from_transcript(Transcript, [H|T], Result) :-
    select(H, Transcript, R),
    remove_from_transcript(R, T, Result).

check_difference(Transcript, [], Transcript).
check_difference(Transcript, Result, Difference):-
    subtract(Transcript, Difference, Result).


%% --- First year Math.. Any of these count as first year math. There are 2 requirements for this. 
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math100], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math102], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math104], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math180], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math184], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math120], R).
first_year_math1(Transcript, R) :- remove_from_transcript(Transcript, [math110], R).

first_year_math2(Transcript, R) :- remove_from_transcript(Transcript, [math101], R).
first_year_math2(Transcript, R) :- remove_from_transcript(Transcript, [math103], R).
first_year_math2(Transcript, R) :- remove_from_transcript(Transcript, [math105], R).
first_year_math2(Transcript, R) :- remove_from_transcript(Transcript, [math121], R).

%% --- Second year Math
second_year_math(Transcript, R) :- remove_from_transcript(Transcript, [math200], R).
second_year_math(Transcript, R) :- remove_from_transcript(Transcript, [math221], R).
second_year_math(Transcript, R) :- remove_from_transcript(Transcript, [stat200], R).
second_year_math(Transcript, R) :- remove_from_transcript(Transcript, [stat241], R).
%% 						COURSE DECLARATIONS
%% ----------------------------------------------------------------

%% CPSC COURSE DECLARATIONS

%% CPSC 100 levels

prop(cpsc100,number,100).
prop(cpsc100,department,cpsc).

prop(cpsc103,number,103).
prop(cpsc103,department,cpsc).

prop(cpsc110,number,110).
prop(cpsc110,department,cpsc).

prop(cpsc121,number,121).
prop(cpsc121,department,cpsc).


% CPSC 200 levels

prop(cpsc210, number, 210).
prop(cpsc210, department, cpsc). 

prop(cpsc213, number, 213).
prop(cpsc213, department, cpsc). 

prop(cpsc221, number, 221).
prop(cpsc221, department, cpsc). 


% CPSC 300 levels
prop(cpsc301, number, 301).
prop(cpsc301, department, cpsc). 

prop(cpsc302, number, 302).
prop(cpsc302, department, cpsc). 

prop(cpsc303, number, 303).
prop(cpsc303, department, cpsc). 

prop(cpsc304, number, 304).
prop(cpsc304, department, cpsc). 

prop(cpsc310, number, 310).
prop(cpsc310, department, cpsc). 

prop(cpsc311, number, 311).
prop(cpsc311, department, cpsc). 

prop(cpsc312, number, 312).
prop(cpsc312, department, cpsc). 

prop(cpsc313, number, 313).
prop(cpsc313, department, cpsc). 

prop(cpsc314, number, 314).
prop(cpsc314, department, cpsc). 

prop(cpsc317, number, 317).
prop(cpsc317, department, cpsc). 

prop(cpsc319, number, 319).
prop(cpsc319, department, cpsc). 

prop(cpsc320, number, 320).
prop(cpsc320, department, cpsc). 

prop(cpsc322, number, 322).
prop(cpsc322, department, cpsc). 

prop(cpsc340, number, 340).
prop(cpsc340, department, cpsc). 

prop(cpsc344, number, 344).
prop(cpsc344, department, cpsc). 

prop(cpsc349, number, 349).
prop(cpsc349, department, cpsc). 


% CPSC 400 levels

prop(cpsc404,number,404).
prop(cpsc404,department,cpsc).

prop(cpsc406,number,406).
prop(cpsc406,department,cpsc).

prop(cpsc410,number,410).
prop(cpsc410,department,cpsc).

prop(cpsc411,number,411).
prop(cpsc411,department,cpsc).

prop(cpsc415,number,415).
prop(cpsc415,department,cpsc).

prop(cpsc416,number,416).
prop(cpsc416,department,cpsc).

prop(cpsc418,number,418).
prop(cpsc418,department,cpsc).

prop(cpsc420,number,420).
prop(cpsc420,department,cpsc).

prop(cpsc421,number,421).
prop(cpsc421,department,cpsc).

prop(cpsc422,number,422).
prop(cpsc422,department,cpsc).

prop(cpsc424,number,424).
prop(cpsc424,department,cpsc).

prop(cpsc436D,number,436).
prop(cpsc436D,department,cpsc).

prop(cpsc444,number,444).
prop(cpsc444,department,cpsc).

prop(cpsc445,number,445).
prop(cpsc445,department,cpsc).

prop(cpsc448,number,448).
prop(cpsc448,department,cpsc).

prop(cpsc449,number,449).
prop(cpsc449,department,cpsc).

prop(cpsc490,number,490).
prop(cpsc490,department,cpsc).
