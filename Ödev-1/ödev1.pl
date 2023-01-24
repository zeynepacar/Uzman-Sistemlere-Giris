sarj(s). %sarj aletinin hangi odada bulunduğunun tanımı

kapi(k,y).
kapi(y,c).
kapi(c,m).
kapi(m,o).
kapi(o,s).
kapi(o,a). %hangi odalardan hangi odalara kapi oldugunun tanımlanması 

gider(X,Y):-kapi(X,Y);kapi(Y,X). %bir odadan digerine kapi varsa gitme olayi

%bir elemanin bir dizide bulunup bulunmadiğini bulma
eleman(Element,[Element|_]). %eger dizinin ilk elemaniysa
eleman(Element,[_|Tail]):-eleman(Element,Tail). %elemani bulamadikca dizi uzerinde rekursif olarak diziyi kontrol ediyoruz

%supurgenin odalara gidip sarj aletini bulmasi 
git(X,X,_,_,[X]):-sarj(X). %sarj aletinin bulundugu odaya geldiyse durma noktasi
git(X,Y,Gidildi,Gitme,[X|T]):-gider(X,Z),not(eleman(Z,Gitme)),not(eleman(Z,Gidildi)),git(Z,Y,[Z|Gidildi],Gitme,T).
%not komutlarıyla daha onceden gidilen odaların ve gidilmemesi istenen odalar kontrol edilip robotumuz ona gore ilerliyor sarj aletine ulasmadigi surece gidebilecegi odalari geziyor