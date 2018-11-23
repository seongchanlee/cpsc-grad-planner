
graduated(Transcript, Unused) :-
    complete(Transcript, _, _, _).

%%complete([cpsc110, cpsc121, math100, math101, cpsc210, cpsc213, cpsc221, math200, stat200, cpsc310, cpsc313, cpsc320, cpsc322, cpsc304, cpsc311, cpsc312, cpsc404, cpsc411, cpsc410], CS, _,_).
%% try complete([cpsc110, cpsc121, cpsc200, cpsc310, math100, math101, cpsc210, cpsc213, cpsc221, math200, math221], CS, _, _).
complete(Transcript, CSDegreeRequirements, ArtsRequirements, Misc):-
    cs_requirements(Transcript, Result),
    check_difference(Transcript, CSDegreeRequirements, Result).
%% add arts and misc here


%%                  CS REQUIREMENTS
%% --------------------------------------------------------------------------------
cs_requirements(Transcript, Result):-
    first_year_cs_requirements(Transcript, Res1),
    second_year_cs_requirements(Res1, Res2),
    thirdfourth_year_cs_requirements(Res2, Result). 

first_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc110, cpsc121], Res1),
    first_year_math1(Res1, Res2),
    first_year_math2(Res2, Result).

second_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc210, cpsc213, cpsc221], Res1),
    second_year_math(Res1, Res2),
    second_year_math(Res2, Result).

thirdfourth_year_cs_requirements(Transcript, Result) :-
    remove_from_transcript(Transcript, [cpsc310, cpsc313, cpsc320], Res1),
    %% 4, 300 level CPSC courses (12 Credits)
    threehunnid_level_CPSC(Res1, _, Res2),
    threehunnid_level_CPSC(Res2, _, Res3),
    threehunnid_level_CPSC(Res3, _, Res4),
    threehunnid_level_CPSC(Res4, _, Res5),
    %% 3, 400 level CPSC courses (9 credits)
    fourhunnid_level_CPSC(Res5, _, Res6),
    fourhunnid_level_CPSC(Res6, _, Res7),
    fourhunnid_level_CPSC(Res7, _, Result).

threehunnid_level_CPSC(Transcript, Course, Result) :-
    prop(Course, number, CourseNumber),
    prop(Course, department, cpsc),
    CourseNumber >= 300,
    CourseNumber < 400,
    select(Course, Transcript, Result).

fourhunnid_level_CPSC(Transcript, Course, Result) :-
    prop(Course, number, CourseNumber),
    prop(Course, department, cpsc),
    CourseNumber >= 400,
    CourseNumber < 500,
    select(Course, Transcript, Result).


%%                ARTS REQUIREMENTS
%% ----------------------------------------------------------------------------------
arts_requirements(Transcript, Result) :-
    language_requirements(Transcript, R1).

language_requirements(Transcript, Result) :-
    lang_req(Transcript, Result).


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


%% --- Meets Arts Language requirement
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [arbc400], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [arbc202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [asla400], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [cnto301], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [cnto311], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin117], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin118], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin243], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin244], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin107], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin108], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin233], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [chin234], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [dani210], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel212], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel222], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel232], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel242], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel252], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel262], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fnel292], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [fren112], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [germ210], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [grek200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [grek202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [hebr405], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [hebr202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [hinu200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [hinu202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [indo200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [indo202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [ital202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [ital203], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [ital206], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [japn103], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [japn151], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [japn201], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [japn260], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [korn200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [korn202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [latn200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [latn202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [pers104], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [pers201], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [pols300], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [port202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [port210], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [punj200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [punj202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [russ200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [sans200], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [sans202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [sans400], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [sans401], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [span112], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [span202], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [swed210], R).
lang_req(Transcript, R) :- remove_from_transcript(Transcript, [ukrn225], R).


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


%% ARTS COURSE DECLARATIONS

%% LANGUAGE REQUIREMENTS

prop(arbc400, number, 400)
prop(arbc400, department, arbc)

prop(arbc202, number, 202)
prop(arbc202, department, arbc)

prop(asla400, number, 400)
prop(asla400, department, asla)

prop(cnto301, number, 301)
prop(cnto301, department, cnto)

prop(cnto311, number, 311)
prop(cnto311, department, cnto)

prop(chin117, number, 117)
prop(chin117, department, chin)

prop(chin118, number, 117)
prop(chin118, department, chin)

prop(chin243, number, 243)
prop(chin243, department, chin)

prop(chin244, number, 244)
prop(chin244, department, chin)

prop(chin107, number, 107)
prop(chin107, department, chin)

prop(chin108, number, 108)
prop(chin108, department, chin)

prop(chin233, number, 233)
prop(chin233, department, chin)

prop(chin234, number, 234)
prop(chin234, department, chin)

prop(dani210, number, 210)
prop(dani210, department, dani)

prop(fnel202, number, 202)
prop(fnel202, department, fnel)

prop(fnel212, number, 212)
prop(fnel212, department, fnel)

prop(fnel222, number, 222)
prop(fnel222, department, fnel)

prop(fnel232, number, 232)
prop(fnel232, department, fnel)

prop(fnel242, number, 242)
prop(fnel242, department, fnel)

prop(fnel252, number, 252)
prop(fnel252, department, fnel)

prop(fnel262, number, 262)
prop(fnel262, department, fnel)

prop(fnel292, number, 292)
prop(fnel292, department, fnel)

prop(fren112, number, 112)
prop(fren112, department, fren)

prop(arbc202, number, 202)
prop(arbc202, department, arbc)

prop(germ210, number, 210)
prop(germ210, department, germ)

prop(grek200, number, 200)
prop(grek200, department, grek)

prop(grek202, number, 202)
prop(grek202, department, grek)

prop(hebr405, number, 405)
prop(hebr405, department, hebr)

prop(hebr202, number, 202)
prop(hebr202, department, hebr)

prop(hinu200, number, 200)
prop(hinu200, department, hinu)

prop(hinu202, number, 202)
prop(hinu202, department, hinu)

prop(indo200, number, 200)
prop(indo200, department, indo)

prop(indo202, number, 202)
prop(indo202, department, indo)

prop(ital202, number, 202)
prop(ital202, department, ital)

prop(ital203, number, 203)
prop(ital203, department, ital)

prop(ital206, number, 206)
prop(ital206, department, ital)

prop(japn103, number, 103)
prop(japn103, department, japn)

prop(japn151, number, 151)
prop(japn151, department, japn)

prop(japn201, number, 201)
prop(japn201, department, japn)

prop(japn260, number, 260)
prop(japn260, department, japn)

prop(korn200, number, 200)
prop(korn200, department, korn)

prop(korn202, number, 202)
prop(korn202, department, korn)

prop(latn200, number, 200)
prop(latn200, department, latn)

prop(latn202, number, 202)
prop(latn202, department, latn)

prop(pers104, number, 104)
prop(pers104, department, pers)

prop(pers201, number, 201)
prop(pers201, department, pers)

prop(pols300, number, 300)
prop(pols300, department, pols)

prop(port202, number, 202)
prop(port202, department, port)

prop(port210, number, 210)
prop(port210, department, port)

prop(punj200, number, 200)
prop(punj200, department, punj)

prop(punj202, number, 202)
prop(punj202, department, punj)

prop(russ200, number, 200)
prop(russ200, department, russ)

prop(sans200, number, 200)
prop(sans200, department, sans)

prop(sans202, number, 202)
prop(sans202, department, sans)

prop(sans400, number, 400)
prop(sans400, department, sans)

prop(sans401, number, 401)
prop(sans401, department, sans)

prop(span112, number, 112)
prop(span112, department, span)

prop(span202, number, 202)
prop(span202, department, span)

prop(swed210, number, 210)
prop(swed210, department, swed)

prop(ukrn225, number, 225)
prop(ukrn225, department, ukrn)

%% RESEARCH REQUIREMENTS

prop(anth317, number, 317)
prop(anth317, department, anth)

prop(anth407, number, 407)
prop(anth407, department, anth)

prop(anth408, number, 408)
prop(anth408, department, anth)

prop(anth417, number, 417)
prop(anth417, department, anth)

prop(anth418, number, 418)
prop(anth418, department, anth)

prop(anth428, number, 428)
prop(anth428, department, anth)

prop(anth431, number, 431)
prop(anth431, department, anth)

prop(anth449, number, 449)
prop(anth449, department, anth)

prop(anth452, number, 452)
prop(anth452, department, anth)

prop(anth478, number, 478)
prop(anth478, department, anth)

prop(arcl306, number, 306)
prop(arcl306, department, arcl)

prop(arcl405, number, 405)
prop(arcl405, department, arcl)

prop(arcl406, number, 406)
prop(arcl406, department, arcl)

prop(arcl419, number, 419)
prop(arcl419, department, arcl)

prop(arth410, number, 410)
prop(arth410, department, arth)

prop(arth432, number, 432)
prop(arth432, department, arth)

prop(arth436, number, 436)
prop(arth436, department, arth)

prop(arth437, number, 437)
prop(arth437, department, arth)

prop(arth439, number, 439)
prop(arth439, department, arth)

prop(arth440, number, 440)
prop(arth440, department, arth)

prop(arth442, number, 442)
prop(arth442, department, arth)

prop(arth443, number, arth443)
prop(arth443, department, arth)

prop(arth445, number, 445)
prop(arth445, department, arth)

prop(arth448, number, 448)
prop(arth448, department, arth)

prop(arth450, number, 450)
prop(arth450, department, arth)

prop(arth455, number, 455)
prop(arth455, department, arth)

prop(arth458, number, 458)
prop(arth458, department, arth)

prop(arth459, number, 459)
prop(arth459, department, arth)

prop(arth464, number, 464)
prop(arth464, department, arth)

prop(arth471, number, 471)
prop(arth471, department, arth)

prop(arth476, number, 476)
prop(arth476, department, arth)

prop(arth479, number, 479)
prop(arth479, department, arth)

prop(arth480, number, 480)
prop(arth480, department, arth)

prop(asia402, number, 402)
prop(asia402, department, asia)

prop(asia408, number, 408)
prop(asia408, department, asia)

prop(asia402, number, 402)
prop(asia402, department, asia)



