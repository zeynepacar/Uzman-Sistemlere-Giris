
<img width="647" alt="Ekran Resmi 2023-01-24 13 12 10" src="https://user-images.githubusercontent.com/83477882/214265153-3ca97f57-d408-41bb-943a-21d6e817bb74.png">

Bir ev içerisinde yukarıda belirtilen koridor (k), yemek odası (y), çocuk odası (c), yemek odası (y), salon (s), oturma odası(o), çamaşır odası (a) bölümlerinden oluşmaktadır. Evin temizlik işlerinde ev sahibine yardım eden robot süpürgenin şarjı bitmek üzere olup şarj istasyonuna gitmesi ve şarj olduktan sonra bulunduğu noktaya geri dönüp süpürme işlemine kaldığı yerden devam etmesi gerekmektedir. Robot süpürgenin süpürge işlemi sırasında yazılımında bir hata olmuş ve yazılım geliştirici olan ev sahibi, süpürgenin yazılımına müdahale edecek ve robot süpürgenin doğru bir şekilde şarj istasyonuna gitmesini sağlayacaktır. Sizlerden de bir ev sahibi olarak süpürgenin rotasını bulmasına yardımcı olacak prolog kodunu yazmanız istenmektedir.
Problemin çözülmesi için gereken işlemler:
1. Mümkün olan herhangi bir kapının önüne gelinir. Başvurulan bölümün adı listede varsa adım
1’e geri dönülür.
2. Girilen odanın başka bir odaya çıkışı olmadığında geri dönülür ve diğer alternatif aranır.
3. Aksi durumda odanın adı listeye kaydedilir.
4. Şarj istasyonu girilen odada aranır.
5. Eğer şarj istasyonuna rastlanmadıysa adım 1’ geri dönülür. Aksi halde işlemler tamamlanır ve
listede olan oda isimleri çıktı olarak verilir.
Hedef: gec (a, X,[]), sarjaleti(X). -> a’dan başlayarak X de bulunan şarj aletine ulaşmak için
gidilecek odalar. İlk durumda boş bir listemiz var.
