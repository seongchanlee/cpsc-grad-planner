
graduated(Transcript) :-
    complete(Transcript, _, _).

%% complete([cpsc110, cpsc121, math100, math101, cpsc210, cpsc213, cpsc221, math200, stat200, cpsc310, cpsc313, cpsc320, cpsc322, cpsc304, cpsc311, cpsc312, cpsc404, cpsc411, cpsc410], CS, _,_).
%% exampleTranscript = [cpsc110, cpsc121, math100, math101, cpsc210, cpsc213, cpsc221, math200, stat200, cpsc310, cpsc313, cpsc320, cpsc311, cpsc319, cpsc322, cpsc340, cpsc410, cpsc424, cpsc422, wrds150, grek200, latn301, slav307, asia212, cens202, fren220, fhis333, germ426, hebr479, ital202, ital203, span112, ukrn225, phil375, pols345, hinu200, hinu202, rmst221, sans300, punj403]

%% try complete([cpsc110, cpsc121, cpsc200, cpsc310, math100, math101, cpsc210, cpsc213, cpsc221, math200, math221], CS, _, _).
complete(Transcript, CSDegreeRequirements, ArtsRequirements):-
    cs_requirements(Transcript, Result1),
    check_difference(Transcript, CSDegreeRequirements, Result1),
    arts_requirements(Result1, Result2),
    check_difference(Result1, ArtsRequirements, Result2).


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
    language_requirement(Transcript, R1),
    literature_requirement(R1, R2),
    research_requirement(R2, R3),
    writing_requirement(R3, Result).

language_requirement(Transcript, Result) :-
    % language (3 credits)
    prop(Course, requirement, lang),
    select(Course, Transcript, Result).

literature_requirement(Transcript, Result) :-
    % literature (6 credits)
    prop(Course1, requirement, literature),
    select(Course1, Transcript, R1),
    prop(Course2, requirement, literature),
    select(Course2, R1, Result).

research_requirement(Transcript, Result) :-
    % research (3 credits)
    prop(Course, requirement, research),
    select(Course, Transcript, Result).

writing_requirement(Transcript, Result) :-
    % writing (3 credits)
    prop(Course, requirement, writing),
    select(Course, Transcript, Result).


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


%%            NLP
%% ----------------------------------------------------------------

% Sample run: q(Ans).
% transcript has to be a list; e.g. [cpsc110, cpsc121, ...]
% questions has to be surrounded by the quotation marks; e.g. "can i graduate"

q(Ans) :-
    write("Enter your transcript: "),
    read(Transcript),
    write("Ask me: "),
    read(Ln),
    split_string(Ln, " ", "", Question),
    ask(Transcript, Question, Ans).

ask(Transcript, ["can", "i", "graduate"], yes) :- graduated(Transcript, _).
ask(Transcript, ["did", "i", "finish" | T], yes) :-
  req_finish_sub_question(T, Transcript).
ask(_, ["what", "is", "average", "for", CourseName], Ans) :-
  prop(Course, name, CourseName),
  prop(Course, average, Ans).
ask(_, ["how", "many", "people", "failed", CourseName], Ans) :-
  prop(Course, name, CourseName),
  prop(Course, fail, Ans).
ask(_, ["how", "many", "people", "passed", CourseName], Ans) :-
  prop(Course, name, CourseName),
  prop(Course, pass, Ans).
ask(_, ["who", "is", "the", "instructor", "for", CourseName], Ans) :-
  prop(Course, name, CourseName),
  prop(Course, instructor, Ans).
ask(_, ["what", "are", "the", "courses", "taught", "by", Instructor], Ans) :-
  prop(Ans, instructor, Instructor).

req_finish_sub_question(["first", "year", "cs", "requirements"], Transcript) :-
  first_year_cs_requirements(Transcript, _).

req_finish_sub_question(["second", "year", "cs", "requirements"], Transcript) :-
  second_year_cs_requirements(Transcript, _).

req_finish_sub_question(["upper", "level", "cs", "requirements"], Transcript) :-
  thirdfourth_year_cs_requirements(Transcript, _).

req_finish_sub_question(["language", "requirements"], Transcript) :-
  language_requirement(Transcript, _).

req_finish_sub_question(["literature", "requirements"], Transcript) :-
  literature_requirement(Transcript, _).

req_finish_sub_question(["research", "requirements"], Transcript) :-
  research_requirement(Transcript, _).

req_finish_sub_question(["writing", "requirements"], Transcript) :-
  writing_requirement(Transcript, _).

%% 						COURSE DECLARATIONS
%% ----------------------------------------------------------------

%% CPSC COURSE DECLARATIONS

%% CPSC 100 levels

prop(cpsc100,number,100).
prop(cpsc100,department,cpsc).
prop(cpsc100, credits, 3).
prop(cpsc100, name, "cpsc100").


prop(cpsc103,number,103).
prop(cpsc103,department,cpsc).
prop(cpsc103, credits, 3).
prop(cpsc103, name, "cpsc103").

prop(cpsc110,number,110).
prop(cpsc110,department,cpsc).
prop(cpsc110, credits, 4).
prop(cpsc110, average, 74.79).
prop(cpsc110, instructor, "wolfman").
prop(cpsc110, instructor, "kiczales").
prop(cpsc110, instructor, "aiello").
prop(cpsc110, instructor, "little").
prop(cpsc110, instructor, "allen").
prop(cpsc110, instructor, "berg").
prop(cpsc110, fail, 40).
prop(cpsc110, pass, 256).
prop(cpsc110, name, "cpsc110").

prop(cpsc121,number,121).
prop(cpsc121,department,cpsc).
prop(cpsc121, credits, 4).
prop(cpsc121, average, 76.65).
prop(cpsc121, instructor, "belleville").
prop(cpsc121, instructor, "gao").
prop(cpsc121, instructor, "tsiknis").
prop(cpsc121, fail, 17).
prop(cpsc121, pass, 209).
prop(cpsc121, name, "cpsc121").

% CPSC 200 levels

prop(cpsc210, number, 210).
prop(cpsc210, department, cpsc).
prop(cpsc210, credits, 4).
prop(cpsc210, average, 74.17).
prop(cpsc210, instructor, "baniassad").
prop(cpsc210, instructor, "carter").
prop(cpsc210, instructor, "hutchinson").
prop(cpsc210, fail, 12).
prop(cpsc210, pass, 141).
prop(cpsc210, name, "cpsc210").

prop(cpsc213, number, 213).
prop(cpsc213, department, cpsc).
prop(cpsc213, credits, 4).
prop(cpsc213, average, 71.89).
prop(cpsc213, instructor, "feeley").
prop(cpsc213, fail, 13).
prop(cpsc213, pass, 134).
prop(cpsc213, name, "cpsc213").

prop(cpsc221, number, 221).
prop(cpsc221, department, cpsc).
prop(cpsc221, credits, 4).
prop(cpsc221, average, 74.04).
prop(cpsc221, instructor, "evans").
prop(cpsc221, instructor, "hu").
prop(cpsc221, instructor, "kotthoff").
prop(cpsc221, fail, 8).
prop(cpsc221, pass, 128).
prop(cpsc221, name, "cpsc221").


% CPSC 300 levels
prop(cpsc301, number, 301).
prop(cpsc301, department, cpsc).
prop(cpsc301, credits, 3).
prop(cpsc301, average, 82.99).
prop(cpsc301, instructor, "tsiknis").
prop(cpsc301, fail, 0).
prop(cpsc301, pass, 151).
prop(cpsc301, name, "cpsc301").

prop(cpsc302, number, 302).
prop(cpsc302, department, cpsc).
prop(cpsc302, credits, 3).
prop(cpsc302, average, 79.29).
prop(cpsc302, instructor, "ascher").
prop(cpsc302, fail, 2).
prop(cpsc302, pass, 64).
prop(cpsc302, name, "cpsc302").

prop(cpsc303, number, 303).
prop(cpsc303, department, cpsc).
prop(cpsc303, credits, 3).
prop(cpsc303, average, 74.23).
prop(cpcs303, instructor, "gelbart").
prop(cpsc303, fail, 1).
prop(cpsc303, pass, 64).
prop(cpsc303, name, "cpsc303").

prop(cpsc304, number, 304).
prop(cpsc304, department, cpsc).
prop(cpsc304, credits, 3).
prop(cpsc304, average, 79.56).
prop(cpsc304, instructor, "lakshmanan").
prop(cpsc304, instructor, "ng").
prop(cpsc304, fail, 4).
prop(cpsc304, pass, 155).
prop(cpsc304, name, "cpsc304").

prop(cpsc310, number, 310).
prop(cpsc310, department, cpsc).
prop(cpsc310, credits, 3).
prop(cpsc310, average, 77.13).
prop(cpsc310, instructor, "baniassad").
prop(cpsc310, fail, 3).
prop(cpsc310, pass, 162).
prop(cpsc310, name, "cpsc310").

prop(cpsc311, number, 311).
prop(cpsc311, department, cpsc).
prop(cpsc311, credits, 3).
prop(cpsc311, average, 84.39).
prop(cpsc110, instructor, "dunfield").
prop(cpsc311, fail, 2).
prop(cpsc311, pass, 105).
prop(cpsc311, name, "cpsc311").

prop(cpsc312, number, 312).
prop(cpsc312, department, cpsc).
prop(cpsc312, credits, 3).
prop(cpsc312, average, 76.93).
prop(cpsc110, instructor, "sagaii").
prop(cpsc312, fail, 2).
prop(cpsc312, pass, 138).
prop(cpsc312, name, "cpsc312").

prop(cpsc313, number, 313).
prop(cpsc313, department, cpsc).
prop(cpsc313, credits, 3).
prop(cpsc313, average, 73.62).
prop(cpsc313, instructor, "belleville").
prop(cpsc313, instructor, "acton").
prop(cpsc313, fail, 15).
prop(cpsc313, pass, 176).
prop(cpsc313, name, "cpsc313").

prop(cpsc314, number, 314).
prop(cpsc314, department, cpsc).
prop(cpsc314, credits, 3).
prop(cpsc314, average, 78.7).
prop(cpsc314, instructor, "bessmeltsev").
prop(cpsc314, instructor, "munzner").
prop(cpsc314, fail, 2).
prop(cpsc314, pass, 65).
prop(cpsc314, name, "cpsc314").

prop(cpsc317, number, 317).
prop(cpsc317, department, cpsc).
prop(cpsc317, credits, 3).
prop(cpsc317, average, 73.45).
prop(cpsc317, instructor, "acton").
prop(cpsc317, fail, 7).
prop(cpsc317, pass, 112).
prop(cpsc317, name, "cpsc317").

prop(cpsc319, number, 319).
prop(cpsc319, department, cpsc).
prop(cpsc319, requirement, research).
prop(cpsc319, credits, 4).
prop(cpsc319, average, 87.93).
prop(cpsc319, instructor, "awad").
prop(cpsc319, fail, 0).
prop(cpsc319, pass, 74).
prop(cpsc319, name, "cpsc319").

prop(cpsc320, number, 320).
prop(cpsc320, department, cpsc).
prop(cpsc320, credits, 3).
prop(cpsc320, average, 70.48).
prop(cpsc320, instructor, "manuch").
prop(cpsc320, fail, 12).
prop(cpsc320, pass, 120).
prop(cpsc320, name, "cpsc320").

prop(cpsc322, number, 322).
prop(cpsc322, department, cpsc).
prop(cpsc322, credits, 3).
prop(cpsc322, average, 73.55).
prop(cpsc322, instructor, "conati").
prop(cpsc322, instructor, "poole").
prop(cpsc322, fail, 8).
prop(cpsc322, pass, 108).
prop(cpsc322, name, "cpsc322").

prop(cpsc340, number, 340).
prop(cpsc340, department, cpsc).
prop(cpsc340, credits, 3).
prop(cpsc340, average, 80.29).
prop(cpsc340, instructor, "schmidt").
prop(cpsc340, fail, 1).
prop(cpsc340, pass, 146).
prop(cpsc340, name, "cpsc340").

prop(cpsc344, number, 344).
prop(cpsc344, department, cpsc).
prop(cpsc344, credits, 3).
prop(cpsc344, average, 78.28).
prop(cpsc344, instructor, "maclean").
prop(cpsc344, fail, 2).
prop(cpsc344, pass, 93).
prop(cpsc344, name, "cpsc344").

prop(cpsc349, number, 349).
prop(cpsc349, department, cpsc).
prop(cpsc349, credits, 3).
prop(cpsc349, name, "cpsc349").

% CPSC 400 levels

prop(cpsc404,number,404).
prop(cpsc404,department,cpsc).
prop(cpsc404, credits, 3).
prop(cpsc404, average, 81.82).
prop(cpsc404, instructor, "tsiknis").
prop(cpsc404, fail, 1).
prop(cpsc404, pass, 116).
prop(cpsc404, name, "cpsc404").

prop(cpsc406,number,406).
prop(cpsc406,department,cpsc).
prop(cpsc406, credits, 3).
prop(cpsc406, name, "cpsc406").

prop(cpsc410,number,410).
prop(cpsc410,department,cpsc).
prop(cpsc410, requirement, research).
prop(cpsc410, credits, 3).
prop(cpsc410, average, 79).
prop(cpsc410, instructor, "holmes").
prop(cpsc410, fail, 0).
prop(cpsc410, pass, 118).
prop(cpsc410, name, "cpsc410").

prop(cpsc411,number,411).
prop(cpsc411,department,cpsc).
prop(cpsc411, credits, 3).
prop(cpsc411, average, 86).
prop(cpsc411, instructor, "garcia").
prop(cpsc411, fail, 0).
prop(cpsc411, pass, 44).
prop(cpsc411, name, "cpsc411").

prop(cpsc415,number,415).
prop(cpsc415,department,cpsc).
prop(cpsc415, credits, 3).
prop(cpsc415, average, 72).
prop(cpsc415, instructor, "acton").
prop(cpsc415, fail, 5).
prop(cpsc415, name, "cpsc415").

prop(cpsc416,number,416).
prop(cpsc416,department,cpsc).
prop(cpsc416, credits, 3).
prop(cpsc416, average, 81.18).
prop(cpsc416, instructor, "beschastnikh").
prop(cpsc416, fail, 0).
prop(cpsc416, pass, 77).
prop(cpsc416, name, "cpsc416").

prop(cpsc418,number,418).
prop(cpsc418,department,cpsc).
prop(cpsc418, credits, 3).
prop(cpsc418, average, 86.08).
prop(cpsc418, instructor, "greenstreet").
prop(cpsc418, fail, 0).
prop(cpsc418, pass, 51).
prop(cpsc418, name, "cpsc418").

prop(cpsc420,number,420).
prop(cpsc420,department,cpsc).
prop(cpsc420, credits, 3).
prop(cpsc420, average, 73.63).
prop(cpsc420, instructor, "evans").
prop(cpsc420, fail, 4).
prop(cpsc420, pass, 55).
prop(cpsc420, name, "cpsc420").

prop(cpsc421,number,421).
prop(cpsc421,department,cpsc).
prop(cpsc421, credits, 3).
prop(cpsc421, average, 73.73).
prop(cpsc421, instructor, "fiedman").
prop(cpsc421, name, "cpsc421").

prop(cpsc422,number,422).
prop(cpsc422,department,cpsc).
prop(cpsc422, credits, 3).
prop(cpsc422, average, 74.54).
prop(cpsc422, instructor, "carenini").
prop(cpsc422, fail, 2).
prop(cpsc422, pass, 44).
prop(cpsc422, name, "cpsc422").

prop(cpsc424,number,424).
prop(cpsc424,department,cpsc).
prop(cpsc424, credits, 3).
prop(cpsc424, name, "cpsc424").

prop(cpsc436D,number,436).
prop(cpsc436D,department,cpsc).
prop(cpsc436D, credits, 3).
prop(cpsc436D, name, "cpsc436D").

prop(cpsc444,number,444).
prop(cpsc444,department,cpsc).
prop(cpsc444, requirement, research).
prop(cpsc444, credits, 3).
prop(cpsc444, average, 77.43).
prop(cpsc444, instructor, "dawson").
prop(cpsc444, fail, 0).
prop(cpsc444, pass, 51).
prop(cpsc444, name, "cpsc444").

prop(cpsc445,number,445).
prop(cpsc445,department,cpsc).
prop(cpsc445, credits, 3).
prop(cpsc445, average, 83.59).
prop(cpsc445, instructor, "hoos").
prop(cpsc445, fail, 0).
prop(cpsc445, pass, 32).
prop(cpsc444, name, "cpsc444").

prop(cpsc448,number,448).
prop(cpsc448,department,cpsc).
prop(cpsc448, requirement, research).
prop(cpsc448, credits, 3).
prop(cpsc448, name, "cpsc448").

prop(cpsc449,number,449).
prop(cpsc449,department,cpsc).
prop(cpsc449, requirement, research).
prop(cpsc449, credits, 6).
prop(cpsc449, average, 90.25).
prop(cpsc449, instructor, "tsiknis").
prop(cpsc449, fail, 0).
prop(cpsc449, pass, 4).
prop(cpsc449, name, "cpsc449").

prop(cpsc490,number,490).
prop(cpsc490,department,cpsc).
prop(cpsc490, credits, 3).
prop(cpsc490, average, 84.5).
prop(cpsc490, fail, 0).
prop(cpsc490, pass, 14).
prop(cpsc490, name, "cpsc490").


%% ARTS COURSE DECLARATIONS

%% WRITING REQUIREMENTS

prop(wrds150, number, 150).
prop(wrds150, department, wrds).
prop(wrds150, requirement, writing).
prop(wrds150, credits, 3).

prop(wrds350, number, 350).
prop(wrds350, department, wrds).
prop(wrds350, requirement, writing).
prop(wrds350, credits, 3).

prop(engl100, number, 100).
prop(engl100, department, engl).
prop(engl100, requirement, writing).
prop(engl100, credits, 3).

prop(astu100, number, 100).
prop(astu100, department, astu).
prop(astu100, requirement, writing).
prop(astu100, credits, 3).

prop(astu101, number, 101).
prop(astu101, department, astu).
prop(astu101, requirement, writing).
prop(astu101, credits, 3).



%% LANGUAGE REQUIREMENTS

prop(arbc400, number, 400).
prop(arbc400, department, arbc).
prop(arbc400, requirement, lang).
prop(arb400, credits, 3).

prop(arbc202, number, 202).
prop(arbc202, department, arbc).
prop(arbc202, requirement, lang).
prop(arb202, credits, 3).

prop(asla400, number, 400).
prop(asla400, department, asla).
prop(asla400, requirement, lang).
prop(asla400, credits, 3).

prop(cnto301, number, 301).
prop(cnto301, department, cnto).
prop(cnto301, requirement, lang).
prop(cnto301, credits, 3).

prop(cnto311, number, 311).
prop(cnto311, department, cnto).
prop(cnto311, requirement, lang).
prop(cnto311, credits, 3).

prop(chin117, number, 117).
prop(chin117, department, chin).
prop(chin117, requirement, lang).
prop(chin117, credits, 3).

prop(chin118, number, 117).
prop(chin118, department, chin).
prop(chin118, requirement, lang).
prop(chin118, credits, 3).

prop(chin243, number, 243).
prop(chin243, department, chin).
prop(chin243, requirement, lang).
prop(chin243, credits, 3).

prop(chin244, number, 244).
prop(chin244, department, chin).
prop(chin244, requirement, lang).
prop(chin244, credits, 3).

prop(chin107, number, 107).
prop(chin107, department, chin).
prop(chin107, requirement, lang).
prop(chin107, credits, 3).

prop(chin108, number, 108).
prop(chin108, department, chin).
prop(chin108, requirement, lang).
prop(chin108, credits, 3).

prop(chin233, number, 233).
prop(chin233, department, chin).
prop(chin233, requirement, lang).
prop(chin233, credits, 3).

prop(chin234, number, 234).
prop(chin234, department, chin).
prop(chin234, requirement, lang).
prop(chin234, credits, 3).

prop(dani210, number, 210).
prop(dani210, department, dani).
prop(dani210, requirement, lang).
prop(dani210, credits, 3).

prop(fnel202, number, 202).
prop(fnel202, department, fnel).
prop(fnel202, requirement, lang).
prop(fnel202, credits, 3).

prop(fnel212, number, 212).
prop(fnel212, department, fnel).
prop(fnel212, requirement, lang).
prop(fnel212, credits, 3).

prop(fnel222, number, 222).
prop(fnel222, department, fnel).
prop(fnel222, requirement, lang).
prop(fnel222, credits, 3).

prop(fnel232, number, 232).
prop(fnel232, department, fnel).
prop(fnel232, requirement, lang).
prop(fnel232, credits, 3).

prop(fnel242, number, 242).
prop(fnel242, department, fnel).
prop(fnel242, requirement, lang).
prop(fnel242, credits, 3).

prop(fnel252, number, 252).
prop(fnel252, department, fnel).
prop(fnel252, requirement, lang).
prop(fnel252, credits, 3).

prop(fnel262, number, 262).
prop(fnel262, department, fnel).
prop(fnel262, requirement, lang).
prop(fnel262, credits, 3).

prop(fnel292, number, 292).
prop(fnel292, department, fnel).
prop(fnel292, requirement, lang).
prop(fnel292, credits, 3).

prop(fren112, number, 112).
prop(fren112, department, fren).
prop(fren112, requirement, lang).
prop(fren112, credits, 3).

prop(germ210, number, 210).
prop(germ210, department, germ).
prop(germ210, requirement, lang).
prop(germ210, credits, 3).

prop(grek200, number, 200).
prop(grek200, department, grek).
prop(grek200, requirement, lang).
prop(grek200, credits, 3).

prop(grek202, number, 202).
prop(grek202, department, grek).
prop(grek202, requirement, lang).
prop(grek202, credits, 3).

prop(hebr405, number, 405).
prop(hebr405, department, hebr).
prop(hebr405, requirement, lang).
prop(hebr405, credits, 3).

prop(hebr202, number, 202).
prop(hebr202, department, hebr).
prop(hebr202, requirement, lang).
prop(hebr202, credits, 3).

prop(hinu200, number, 200).
prop(hinu200, department, hinu).
prop(hinu200, requirement, lang).
prop(hinu200, credits, 3).

prop(hinu202, number, 202).
prop(hinu202, department, hinu).
prop(hinu202, requirement, lang).
prop(hinu202, credits, 3).

prop(indo200, number, 200).
prop(indo200, department, indo).
prop(indo200, requirement, lang).
prop(indo200, credits, 3).

prop(indo202, number, 202).
prop(indo202, department, indo).
prop(indo202, requirement, lang).
prop(into202, credits, 3).

prop(ital202, number, 202).
prop(ital202, department, ital).
prop(ital202, requirement, lang).
prop(ital202, credits, 3).

prop(ital203, number, 203).
prop(ital203, department, ital).
prop(ital203, requirement, lang).
prop(ital203, credits, 3).

prop(ital206, number, 206).
prop(ital206, department, ital).
prop(ital206, requirement, lang).
prop(ital206, credits, 3).

prop(japn103, number, 103).
prop(japn103, department, japn).
prop(japn103, requirement, lang).
prop(japn103, credits, 3).

prop(japn151, number, 151).
prop(japn151, department, japn).
prop(japn151, requirement, lang).
prop(japn151, credits, 3).

prop(japn201, number, 201).
prop(japn201, department, japn).
prop(japn201, requirement, lang).
prop(japn201, credits, 3).

prop(japn260, number, 260).
prop(japn260, department, japn).
prop(japn260, requirement, lang).
prop(japn260, credits, 3).

prop(korn200, number, 200).
prop(korn200, department, korn).
prop(korn200, requirement, lang).
prop(korn200, credits, 3).

prop(korn202, number, 202).
prop(korn202, department, korn).
prop(korn202, requirement, lang).
prop(korn202, credits, 3).

prop(latn200, number, 200).
prop(latn200, department, latn).
prop(latn200, requirement, lang).
prop(latn200, credits, 3).

prop(latn202, number, 202).
prop(latn202, department, latn).
prop(latn202, requirement, lang).
prop(latn202, credits, 3).

prop(pers104, number, 104).
prop(pers104, department, pers).
prop(pers104, requirement, lang).
prop(pers104, credits, 3).

prop(pers201, number, 201).
prop(pers201, department, pers).
prop(pers201, requirement, lang).
prop(pers201, credits, 3).

prop(pols300, number, 300).
prop(pols300, department, pols).
prop(pols300, requirement, lang).
prop(pols300, credits, 3).

prop(port202, number, 202).
prop(port202, department, port).
prop(port202, requirement, lang).
prop(port202, credits, 3).

prop(port210, number, 210).
prop(port210, department, port).
prop(port210, requirement, lang).
prop(port210, credits, 3).

prop(punj200, number, 200).
prop(punj200, department, punj).
prop(punj200, requirement, lang).
prop(punj200, credits, 3).

prop(punj202, number, 202).
prop(punj202, department, punj).
prop(punj202, requirement, lang).
prop(punj202, credits, 3).

prop(russ200, number, 200).
prop(russ200, department, russ).
prop(russ200, requirement, lang).
prop(russ200, credits, 3).

prop(sans200, number, 200).
prop(sans200, department, sans).
prop(sans200, requirement, lang).
prop(sans200, credits, 3).

prop(sans202, number, 202).
prop(sans202, department, sans).
prop(sans202, requirement, lang).
prop(sans202, credits, 3).

prop(sans400, number, 400).
prop(sans400, department, sans).
prop(sans400, requirement, lang).
prop(sans400, credits, 3).

prop(sans401, number, 401).
prop(sans401, department, sans).
prop(sans401, requirement, lang).
prop(sans401, credits, 3).

prop(span112, number, 112).
prop(span112, department, span).
prop(span112, requirement, lang).
prop(span112, credits, 3).

prop(span202, number, 202).
prop(span202, department, span).
prop(span202, requirement, lang).
prop(span202, credits, 3).

prop(swed210, number, 210).
prop(swed210, department, swed).
prop(swed210, requirement, lang).
prop(swed210, credits, 3).

prop(ukrn225, number, 225).
prop(ukrn225, department, ukrn).
prop(ukrn225, requirement, lang).
prop(ukrn225, credits, 3).

%% LITERATURE REQUIREMENTS

prop(afst351, number, 351).
prop(afst351, department, afst).
prop(afst351, requirement, literature).

prop(arbc400, number, 400).
prop(arbc400, department, arbc).
prop(arbc400, requirement, literature).

prop(arbc420, number, 420).
prop(arbc420, department, arbc).
prop(arbc420, requirement, literature).

prop(asia212, number, 212).
prop(asia212, department, asia).
prop(asia212, requirement, literature).

prop(asia213, number, 213).
prop(asia213, department, asia).
prop(asia213, requirement, literature).

prop(asia254, number, 254).
prop(asia254, department, asia).
prop(asia254, requirement, literature).

prop(asia308, number, 308).
prop(asia308, department, asia).
prop(asia308, requirement, literature).

prop(asia324, number, 324).
prop(asia324, department, asia).
prop(asia324, requirement, literature).

prop(asia326, number, 326).
prop(asia326, department, asia).
prop(asia326, requirement, literature).

prop(asia334, number, 334).
prop(asia334, department, asia).
prop(asia334, requirement, literature).

prop(asia341, number, 341).
prop(asia341, department, asia).
prop(asia341, requirement, literature).

prop(asia342, number, 342).
prop(asia342, department, asia).
prop(asia342, requirement, literature).

prop(asia347, number, 347).
prop(asia347, department, asia).
prop(asia347, requirement, literature).

prop(astu100, number, 100).
prop(astu100, department, astu).
prop(astu100, requirement, literature).

prop(cens202, number, 202).
prop(cens202, department, cens).
prop(cens202, requirement, literature).

prop(cens303, number, 303).
prop(cens303, department, cens).
prop(cens303, requirement, literature).

prop(cens307, number, 307).
prop(cens307, department, cens).
prop(cens307, requirement, literature).

prop(chin411, number, 411).
prop(chin411, department, chin).
prop(chin411, requirement, literature).

prop(chin413, number, 413).
prop(chin413, department, chin).
prop(chin413, requirement, literature).

prop(chin421, number, 421).
prop(chin421, department, chin).
prop(chin421, requirement, literature).

prop(chin431, number, 431).
prop(chin431, department, chin).
prop(chin431, requirement, literature).

prop(chin433, number, 433).
prop(chin433, department, chin).
prop(chin433, requirement, literature).

prop(chin434, number, 434).
prop(chin434, department, chin).
prop(chin434, requirement, literature).

prop(chin451, number, 451).
prop(chin451, department, chin).
prop(chin451, requirement, literature).

prop(chin453, number, 453).
prop(chin453, department, chin).
prop(chin453, requirement, literature).

prop(chin455, number, 455).
prop(chin455, department, chin).
prop(chin455, requirement, literature).

prop(chin457, number, 457).
prop(chin457, department, chin).
prop(chin457, requirement, literature).

prop(clst310, number, 310).
prop(clst310, department, clst).
prop(clst310, requirement, literature).

prop(clst313, number, 313).
prop(clst313, department, clst).
prop(clst313, requirement, literature).

prop(clst314, number, 314).
prop(clst314, department, clst).
prop(clst314, requirement, literature).

prop(clst315, number, 315).
prop(clst315, department, clst).
prop(clst315, requirement, literature).

prop(clst317, number, 317).
prop(clst317, department, clst).
prop(clst317, requirement, literature).

prop(clst318, number, 318).
prop(clst318, department, clst).
prop(clst318, requirement, literature).

prop(clst402, number, 402).
prop(clst402, department, clst).
prop(clst402, requirement, literature).

prop(fnis454, number, 454).
prop(fnis454, department, fnis).
prop(fnis454, requirement, literature).

prop(fren220, number, 220).
prop(fren220, department, fren).
prop(fren220, requirement, literature).

prop(fren221, number, 221).
prop(fren221, department, fren).
prop(fren221, requirement, literature).

prop(fren280, number, 280).
prop(fren280, department, fren).
prop(fren280, requirement, literature).

prop(fren320, number, 320).
prop(fren320, department, fren).
prop(fren320, requirement, literature).

prop(fren321, number, 321).
prop(fren321, department, fren).
prop(fren321, requirement, literature).

prop(fren328, number, 328).
prop(fren328, department, fren).
prop(fren328, requirement, literature).

prop(fren329, number, 329).
prop(fren329, department, fren).
prop(fren329, requirement, literature).

prop(fren330, number, 330).
prop(fren330, department, fren).
prop(fren330, requirement, literature).

prop(fren348, number, 348).
prop(fren348, department, fren).
prop(fren348, requirement, literature).

prop(fren349, number, 349).
prop(fren349, department, fren).
prop(fren349, requirement, literature).

prop(fhis333, number, 333).
prop(fhis333, department, fhis).
prop(fhis333, requirement, literature).

prop(grsj224, number, 224).
prop(grsj224, department, grsj).
prop(grsj224, requirement, literature).

prop(germ301, number, 301).
prop(germ301, department, germ).
prop(germ301, requirement, literature).

prop(germ302, number, 302).
prop(germ302, department, germ).
prop(germ302, requirement, literature).

prop(germ303, number, 303).
prop(germ303, department, germ).
prop(germ303, requirement, literature).

prop(germ304, number, 304).
prop(germ304, department, germ).
prop(germ304, requirement, literature).

prop(germ305, number, 305).
prop(germ305, department, germ).
prop(germ305, requirement, literature).

prop(germ360, number, 360).
prop(germ360, department, germ).
prop(germ360, requirement, literature).

prop(germ370, number, 370).
prop(germ370, department, germ).
prop(germ370, requirement, literature).

prop(germ380, number, 380).
prop(germ380, department, germ).
prop(germ380, requirement, literature).

prop(germ390, number, 390).
prop(germ390, department, germ).
prop(germ390, requirement, literature).

prop(germ401, number, 401).
prop(germ401, department, germ).
prop(germ401, requirement, literature).

prop(grek301, number, 301).
prop(grek301, department, grek).
prop(grek301, requirement, literature).

prop(grek351, number, 351).
prop(grek351, department, grek).
prop(grek351, requirement, literature).

prop(grek352, number, 352).
prop(grek352, department, grek).
prop(grek352, requirement, literature).

prop(grek401, number, 401).
prop(grek401, department, grek).
prop(grek401, requirement, literature).

prop(grek402, number, 402).
prop(grek402, department, grek).
prop(grek402, requirement, literature).

prop(hebr479, number, 479).
prop(hebr479, department, hebr).
prop(hebr479, requirement, literature).

prop(hinu400, number, 400).
prop(hinu400, department, hinu).
prop(hinu400, requirement, literature).

prop(ital303, number, 303).
prop(ital303, department, ital).
prop(ital303, requirement, literature).

prop(ital304, number, 304).
prop(ital304, department, ital).
prop(ital304, requirement, literature).

prop(ital403, number, 403).
prop(ital403, department, ital).
prop(ital403, requirement, literature).

prop(ital404, number, 404).
prop(ital404, department, ital).
prop(ital404, requirement, literature).

prop(ital405, number, 405).
prop(ital405, department, ital).
prop(ital405, requirement, literature).

prop(ital406, number, 406).
prop(ital406, department, ital).
prop(ital406, requirement, literature).

prop(ital407, number, 407).
prop(ital407, department, ital).
prop(ital407, requirement, literature).

prop(ital408, number, 408).
prop(ital408, department, ital).
prop(ital408, requirement, literature).

prop(ital409, number, 409).
prop(ital409, department, ital).
prop(ital409, requirement, literature).

prop(ital420, number, 420).
prop(ital420, department, ital).
prop(ital420, requirement, literature).

prop(itst231, number, 231).
prop(itst231, department, itst).
prop(itst231, requirement, literature).

prop(itst232, number, 232).
prop(itst232, department, itst).
prop(itst232, requirement, literature).

prop(itst333, number, 333).
prop(itst333, department, itst).
prop(itst33, requirement, literature).

prop(itst345, number, 345).
prop(itst345, department, itst).
prop(ists345, requirement, literature).

prop(itst385, number, 385).
prop(itst385, department, itst).
prop(ists385, requirement, literature).

prop(itst413, number, 413).
prop(itst413, department, itst).
prop(ists413, requirement, literature).

prop(itst414, number, 414).
prop(itst414, department, itst).
prop(ists414, requirement, literature).

prop(itst415, number, 415).
prop(itst415, department, itst).
prop(itst415, requirement, literature).

prop(itst416, number, 416).
prop(itst416, department, itst).
prop(itst416, requirement, literature).

prop(itst417, number, 417).
prop(itst417, department, itst).
prop(itst417, requirement, literature).

prop(japn311, number, 311).
prop(japn311, department, japn).
prop(japn311, requirement, literature).

prop(japn312, number, 312).
prop(japn312, department, japn).
prop(japn312, requirement, literature).

prop(japn342, number, 342).
prop(japn342, department, japn).
prop(japn342, requirement, literature).

prop(japn406, number, 406).
prop(japn406, department, japn).
prop(japn406, requirement, literature).

prop(japn408, number, 408).
prop(japn408, department, japn).
prop(japn408, requirement, literature).

prop(japn422, number, 422).
prop(japn422, department, japn).
prop(japn422, requirement, literature).

prop(japn423, number, 423).
prop(japn423, department, japn).
prop(japn423, requirement, literature).

prop(japn452, number, 452).
prop(japn452, department, japn).
prop(japn452, requirement, literature).

prop(japn453, number, 453).
prop(japn453, department, japn).
prop(japn453, requirement, literature).

prop(korn410, number, 410).
prop(korn410, department, korn).
prop(korn410, requirement, literature).

prop(latn301, number, 301).
prop(latn301, department, latn).
prop(latn301, requirement, literature).

prop(latn350, number, 350).
prop(latn350, department, latn).
prop(latn350, requirement, literature).

prop(latn351, number, 351).
prop(latn351, department, latn).
prop(latn351, requirement, literature).

prop(latn401, number, 401).
prop(latn401, department, latn).
prop(latn401, requirement, literature).

prop(latn402, number, 402).
prop(latn402, department, latn).
prop(latn402, requirement, literature).

prop(mdvl301, number, 301).
prop(mdvl301, department, mdvl).
prop(mdvl301, requirement, literature).

prop(mdvl302, number, 302).
prop(mdvl302, department, mdvl).
prop(mdvl302, requirement, literature).

prop(phil375, number, 375).
prop(phil375, department, phil).
prop(phil375, requirement, literature).

prop(pols345, number, 345).
prop(pols345, department, pols).
prop(pols345, requirement, literature).

prop(pols424, number, 424).
prop(pols424, department, pols).
prop(pols424, requirement, literature).

prop(pols426, number, 426).
prop(pols426, department, pols).
prop(pols426, requirement, literature).

prop(port392, number, 392).
prop(port392, department, port).
prop(port392, requirement, literature).

prop(port405, number, 405).
prop(port405, department, port).
prop(port405, requirement, literature).

prop(punj300, number, 300).
prop(punj300, department, punj).
prop(punj300, requirement, literature).

prop(punj400, number, 400).
prop(punj400, department, punj).
prop(punj400, requirement, literature).

prop(punj401, number, 401).
prop(punj401, department, punj).
prop(punj401, requirement, literature).

prop(punj402, number, 402).
prop(punj402, department, punj).
prop(punj402, requirement, literature).

prop(punj403, number, 403).
prop(punj403, department, punj).
prop(punj403, requirement, literature).

prop(punj404, number, 404).
prop(punj404, department, punj).
prop(punj404, requirement, literature).

prop(relg201, number, 201).
prop(relg201, department, relg).
prop(relg201, requirement, literature).

prop(relg203, number, 203).
prop(relg203, department, relg).
prop(relg203, requirement, literature).

prop(relg209, number, 209).
prop(relg209, department, relg).
prop(relg209, requirement, literature).

prop(relg307, number, 307).
prop(relg307, department, relg).
prop(relg307, requirement, literature).

prop(relg311, number, 311).
prop(relg311, department, relg).
prop(relg311, requirement, literature).

prop(relg320, number, 320).
prop(relg320, department, relg).
prop(relg320, requirement, literature).

prop(relg321, number, 321).
prop(relg321, department, relg).
prop(relg321, requirement, literature).

prop(rmst221, number, 221).
prop(rmst221, department, rmst).
prop(rmst221, requirement, literature).

prop(rmst222, number, 222).
prop(rmst222, department, rmst).
prop(rmst222, requirement, literature).

prop(rmst420, number, 420).
prop(rmst420, department, rmst).
prop(rmst420, requirement, literature).

prop(russ206, number, 206).
prop(russ206, department, russ).
prop(russ206, requirement, literature).

prop(russ207, number, 207).
prop(russ207, department, russ).
prop(russ207, requirement, literature).

prop(russ305, number, 305).
prop(russ305, department, russ).
prop(russ305, requirement, literature).

prop(russ306, number, 306).
prop(russ306, department, russ).
prop(russ306, requirement, literature).

prop(russ321, number, 321).
prop(russ321, department, russ).
prop(russ321, requirement, literature).

prop(russ407, number, 407).
prop(russ407, department, russ).
prop(russ407, requirement, literature).

prop(russ408, number, 408).
prop(russ408, department, russ).
prop(russ408, requirement, literature).

prop(russ409, number, 409).
prop(russ409, department, russ).
prop(russ409, requirement, literature).

prop(russ410, number, 410).
prop(russ410, department, russ).
prop(russ410, requirement, literature).

prop(russ411, number, 411).
prop(russ411, department, russ).
prop(russ411, requirement, literature).

prop(sans300, number, 300).
prop(sans300, department, sans).
prop(sans300, requirement, literature).

prop(sans450, number, 450).
prop(sans450, department, sans).
prop(sans450, requirement, literature).

prop(scan333, number, 333).
prop(scan333, department, scan).
prop(scan333, requirement, literature).

prop(scan334, number, 334).
prop(scan334, department, scan).
prop(scan334, requirement, literature).

prop(scan335, number, 335).
prop(scan335, department, scan).
prop(scan335, requirement, literature).

prop(scan336, number, 336).
prop(scan336, department, scan).
prop(scan336, requirement, literature).

prop(scan411, number, 411).
prop(scan411, department, scan).
prop(scan411, requirement, literature).

prop(scan412, number, 412).
prop(scan412, department, scan).
prop(scan412, requirement, literature).

prop(scan413, number, 413).
prop(scan413, department, scan).
prop(scan413, requirement, literature).

prop(scan414, number, 414).
prop(scan414, department, scan).
prop(scan414, requirement, literature).

prop(scan415, number, 415).
prop(scan415, department, scan).
prop(scan415, requirement, literature).

prop(slav307, number, 307).
prop(slav307, department, slav).
prop(slav307, requirement, literature).

prop(span221, number, 221).
prop(span221, department, span).
prop(span221, requirement, literature).
prop(span221, credits, 3).

prop(span222, number, 222).
prop(span222, department, span).
prop(span222, requirement, literature).
prop(span222, credits, 3).

prop(span280, number, 280).
prop(span280, department, span).
prop(span280, requirement, literature).
prop(span280, credits, 3).

prop(span312, number, 312).
prop(span312, department, span).
prop(span312, requirement, literature).
prop(span312, credits, 6).

prop(span357, number, 357).
prop(span357, department, span).
prop(span357, requirement, literature).
prop(span357, credits, 3).

prop(span358, number, 358).
prop(span358, department, span).
prop(span358, requirement, literature).
prop(span358, credit, 3).

prop(span364, number, 364).
prop(span364, department, span).
prop(span364, requirement, literature).
prop(span364, credit, 3).

prop(span365, number, 365).
prop(span365, department, span).
prop(span365, requirement, literature).
prop(span365, credits, 3).

prop(span406, number, 406).
prop(span406, department, span).
prop(span406, requirement, literature).
prop(span406, credits, 3).

prop(span410, number, 410).
prop(span410, department, span).
prop(span410, requirement, literature).
prop(span410, credits, 6).

prop(thtr210, number, 210).
prop(thtr210, department, thtr).
prop(thtr210, requirement, literature).
prop(thtr210, credits, 3).

prop(thtr211, number, 211).
prop(thtr211, department, thtr).
prop(thtr211, requirement, literature).
prop(thtr211, credits, 3).

prop(thtr245, number, 245).
prop(thtr245, department, thtr).
prop(thtr245, requirement, literature).
prop(thtr245, credits, 3).

prop(thtr310, number, 310).
prop(thtr310, department, thtr).
prop(thtr310, requirement, literature).
prop(thtr310, credits, 3).

prop(thtr311, number, 311).
prop(thtr311, department, thtr).
prop(thtr311, requirement, literature).
prop(thtr311, credits, 3).

prop(thtr410, number, 410).
prop(thtr410, department, thtr).
prop(thtr410, requirement, literature).
prop(thtr410, credits, 3).



