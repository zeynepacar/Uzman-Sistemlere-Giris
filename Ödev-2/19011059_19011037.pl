%oyuncu(isim,cinsiyet,boy,koşu,zıplama)
player(betül,k,167,3,4).
player(zeynep,k,164,4,3).
player(erdem,e,186,10,10).
player(fazıl,e,110,3,6).
player(diyar,e,170,7,5).
player(berat,e,172,5,4).
player(samet,e,186,6,7).
player(muhammed,e,176,3,3).
player(zaide,k,165,6,2).
player(nilsu,k,159,4,2).


players(Players):-findall(Player, player(Player, _, _, _, _), Players).
playercount(X):-players(Players),length(Players,X).

jump(X):-player(X,_,_,_,Y) , (Y > 3).

run(X):-player(X,_,_,Y,_) , (Y > 5).

%defence(name,match,dcount,stallout,playermissout)

defence(betül,1,1,0,2).
defence(zeynep,1,1,0,3).
defence(erdem,1,7,4,2).
defence(fazıl,1,3,0,1).
defence(diyar,1,4,1,3).
defence(berat,1,2,0,6).
defence(samet,1,5,0,2).
defence(muhammed,1,1,1,7).
defence(zaide,1,1,0,1).
defence(nilsu,1,1,0,8).

defence(betül,2,2,0,0).
defence(zeynep,2,3,1,1).
defence(erdem,2,9,4,0).
defence(fazıl,2,5,2,0).
defence(diyar,2,6,1,2).
defence(berat,2,2,1,2).
defence(samet,2,5,4,3).
defence(muhammed,2,5,1,4).
defence(zaide,2,2,0,0).
defence(nilsu,2,3,1,5).



defencepoint(X,Z,Y):-
    defence(X,Z,Dcount,Stall,Miss),
    (   Miss>10 
    ->  Y is (Dcount*2 + Stall - Miss*0.1)/3
    ;   Y is (Dcount*2 + Stall)/2
    ).

compare_points_desc(Order, [_, APoint1], [_, APoint2]) :-
    compare(Order, APoint2, APoint1).

alldefencepoint(Match,DPairs) :-
    findall([Player, DPoint], defencepoint(Player,Match,DPoint), UnsortedDPairs),
    predsort(compare_points_desc, UnsortedDPairs, DPairs).



%attack(name,match,catch,badthrow,drop,stallout,goal,assist)
attack(betül,1,32,4,1,0,4,0).
attack(zeynep,1,38,3,1,1,6,0).
attack(erdem,1,78,1,0,0,26,12).
attack(fazıl,1,85,2,1,1,0,28).
attack(diyar,1,58,8,3,2,12,6).
attack(berat,1,80,2,2,0,2,17).
attack(samet,1,48,9,7,1,18,2).
attack(muhammed,1,32,2,12,2,6,3).
attack(zaide,1,90,4,0,0,0,13).
attack(nilsu,1,19,16,9,4,1,0).

attack(betül,2,30,2,1,0,9,2).
attack(zeynep,2,40,2,1,0,8,3).
attack(erdem,2,75,0,0,0,30,10).
attack(fazıl,2,80,1,0,0,5,32).
attack(diyar,2,65,4,2,3,15,10).
attack(berat,2,83,1,2,0,6,21).
attack(samet,2,50,8,3,1,22,8).
attack(muhammed,2,45,0,9,1,10,8).
attack(zaide,2,75,5,0,0,3,16).
attack(nilsu,2,35,6,7,2,3,1).


%oyunculara atak puanı verme
attackpoint(X,Z,Y):-attack(X,Z,Catch,Badthrow,Drop,Stall,Goal,Assist),
    Y is ( Catch*0.02 - Badthrow*0.5 - Drop*0.5 - Stall + Goal*2 + Assist*2)/6.

allattackpoint(Match,APairs) :-
    findall([Player, APoint], attackpoint(Player,Match,APoint), UnsortedDPairs),
    predsort(compare_points_desc, UnsortedDPairs, APairs).

%oyuncunun savunmada mı atakta mı daha iyi oldugunu bulma
betterat(X,M,Y):-defencepoint(X,M,Z),
    attackpoint(X,M,K),
    (   Z > K
    ->  Y = defence
    ;   Y = attack
    ).

%drill(drillname, field, type(attack/defence))
drills(drill1, throw, attack).
drills(drill2, force, defence).
drills(drill3, catch, attack).
drills(drill4, d, defence).
drills(drill5, cut, insufficient).


suggestdrill(Match,drill1,Result):-
    findall(Name, (attack(Name,Match,CATCH,BADTHROW,_,_,_,_), BADTHROW > CATCH/10), Result).

suggestdrill(Match,drill2,Result):- 
    findall(Name,( defencepoint(Name,Match,Point), Point < 4), Result).

suggestdrill(Match,drill3,Result):-
    findall(Name, (attack(Name,Match,Catch,_,Drop,_,_,_), Catch/4 < Drop), Result).

suggestdrill(Match,drill4,Result):-
    findall(Name, (defence(Name,Match,D,_,_), D < 2), Result).

%drill tipi yazıp o drille kimlerin ihtiyacı olduğu
suggestdrills(X,Match,Result):-drills(Type,X,_),suggestdrill(Match,Type,Result). 

%oyuncuların atak/defans puanından hangisi düşükse ona yönelik drill önerisi                                   
drillsforplayers(Name,Match,Drills):-
    betterat(Name,Match,Y),
    (   Y = defence 
    ->  findall(Drill, drills(Drill,_,attack) , Drills)
    ;   findall(Drill, drills(Drill,_,defence), Drills)
    ).


member(Element,[Element| _ ] ).
member(Element,[ _ |Tail] ):-member(Element,Tail).

position(handler,Match,Result):-
    findall(Name, 
            (attack(Name,Match,Catch,Badthrow,_,Stallout,_,Assist), 
            (Catch*0.5 > Badthrow) , 
            (Stallout =< 3) , 
            (Assist > 10)),
            Result).
%suggestdrill(drill3,Match,Result2), not(member(Name,Result2))

position(cutter,Match,Result):-
               findall(Name, 
                     (attack(Name,Match,_,_,_,_,Goal,_), Goal >= 2 ;
                     not(member(Name,Result)),
                     run(Name)), 
                     Result).

%pozisyonları döndürüyor
positions(Positions):-findall(Position, position(Position,_,_), Positions).

%verilen oyuncunun pozisyonunu döndürür
findposition(Player,Match,Position):-position(P,Match,Result),member(Player,Result), Position = P.

%tüm oyuncuları ve pozisyonlarını listeleme
listallposition(Match,Positions,Players) :-
    findall([Position, Players], position(Position,Match, Players), [Positions,Players]).


%hiç bir pozisyona uygun olmayanlar
findinsufficients(Match,Insufficients):-
    positions(Positions),
    findall(Name,
        (player(Name,_,_,_,_),
         not((member(Position, Positions), position(Position,Match, Result), member(Name, Result)))
        ),
        Insufficients). 

%hiç bir pozisyona uygun olmayanlar için atak/defans daha kötüyse ona yönelik drill önerme ve ekstra drill
drillsforinsufficients(Match,Name,Drills):-
    findinsufficients(Match,Insufficients),
    member(Name,Insufficients),
    betterat(Name,Match,Y),
    (   Y = defence
    ->  findall(Drill, (drills(Drill, _, Type), (Type = attack ; Type = insufficient)), Drills)

    ;   findall(Drill, (drills(Drill, _, Type), (Type = defence ; Type = insufficient)), Drills)
    ).

defencesuccessrate(Player,Match,Rate):- OldMatch is Match-1,
     defencepoint(Player,OldMatch,Old),
   	 defencepoint(Player,Match,New),
   	 (Rate is ((New - Old)/Old)*100).

attacksuccessrate(Player,Match,Rate):- OldMatch is Match-1,
     attackpoint(Player,OldMatch,Old),
   	 attackpoint(Player,Match,New),
   	 (Rate is ((New - Old)/Old)*100).

catchsuccessrate(Player,Match,Result) :-
    OldMatch is Match - 1 ,
    attack(Player,Match,A,_,_,_,_,_),
    attack(Player,OldMatch,B,_,_,_,_,_),
    Result is ((A-B) / B)*100.

 throwsuccessrate(Player,Match,Result) :-
    OldMatch is Match - 1 ,
    attack(Player,Match,_,A,_,_,_,_),
    attack(Player,OldMatch,_,B,_,_,_,_),
    Result is ((B-A) / B)*100.  


 dsuccessrate(Player,Match,Result) :-
    OldMatch is Match - 1 ,
    defence(Player,Match,A,_,_),
    defence(Player,OldMatch,B,_,_),
    Result is ((A-B) / B)*100.  

 playermisssuccessrate(Player,Match,Result) :-
    OldMatch is Match - 1 ,
    defence(Player,Match,_,_,A),
    defence(Player,OldMatch,_,_,B),
    Result is ((B-A) / B)*100. 







    



 
    



    