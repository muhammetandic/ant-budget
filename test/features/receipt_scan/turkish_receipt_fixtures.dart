/// Raw ML Kit output captured from three real Turkish receipts on a T770H.
///
/// Kept verbatim (typos, stray colons, doubled spaces) so the parser keeps
/// being tested against what the recogniser actually produces rather than a
/// cleaned-up idealisation.
library;

/// TAHTAKALE SPOT e-Arşiv invoice. The payable total is 350,30; the trap is the
/// `Toplam` label whose following line is an item count (`: 103`), plus a
/// per-kilogram unit price (`0,565 KG x 620,00`).
const tahtakaleReceipt = '''
Tar ih
Mağ. No
Belge No
TAHTAKALE SPOT Mağazacilik san . Tic.A.5
Unvan
V.D.
EPosta :
Adres
V.D: ANTALYA KURUMLAR VN:816 057 9204
KEPEZ/ ANTALYA TEL:0242 345 06 02
E-Arşiv Fatura
Telefon:
ZAFER MH. 2611 SK. NO:7
:
V.K.N. : 11111111111
16.10.2026
Toplam
: 103
E-Arşiv Gönderim Bilgileri
KDV
:714
RefNo: B112026000123867
AKBANK
%1
:Nih** Tük****
Secen- Soğuk B
2201214 0,565 KG x 620,00-B
Top lam KDV :
ETTN : cc2ae227-89c9-f111-a101-042b5816901c
Saat
YALNIZÜçYüzElliTLOt uzKr
Kasa No
Z No
%1,00
:20:43
:601
:908
KDV Dahil
350, 30
*350,30
3,47
350, 30
350,3
KDV Tutar
*3,47
''';

/// BİM e-Arşiv invoice. The payable total is 75,50; the trap is the street
/// number inside the address (`Lafer Mh. 2622 Sk.`) and the fact that the
/// `Odenecek KDV Dahil Tutar` label also contains `KDV`.
const bimReceipt = '''
E-Arsiv Fatura
BIM BIRLESIK MAGAZALAR A.5.
Lafer Mh. 2622 Sk. R.N. Harç Sitesi
Büyük Mükel lefler VDM 1750051846
FATURA N0:T102026072294913
12.10.2026 14:48
NO:6A KEPEZ/ANTALYA
ETTNc69e5cf1-3b8e-4bb9-af2a-1366d84e26a3
TCKN/VKN:11111111111-NIHAI TÜKETICI
MISR/BUĞ .GEVREĞİ450G %1.
ALIŞVER1Ş POŞETi BiM 220
TOPLAM KDV
Odenecek KDV Dahil Tutar
Banka Kredi Karti (1)
GARANTI BANKASI
13760016101216710108
12.10.2026 14:48
Onay No:150191
KDV MATRAH
21. 73.76
220 0.83
Sira No: 108
B:3080 S:9193
I:2359634 T:03721854 533207******1675
*0.74
*74.50
*0.17
*1.00
*0.91
*75.50
*75.50
Ref.No:628555317743
KDV TUTAR
KDV DAHIL
*74.50
*1.00
''';

/// ŞOK Marketler receipt. The payable total is 293,90; the trap is the store
/// number (`8718 ANTALYA KEPEZ ...`) and the header stack
/// (`TOPKDV` / `TOPLAM` / `KREDİ`) that precedes any amount.
const sokReceipt = '''
TARIH
SAAT
FiŞ NO
TOPKDV
TOPLAM
KREDİ
ETÌ POPKEK LIMONLU 6
ULKER ÇiKOLATA BÍİTTE
ALIŞVERİŞ POŞETİ 43
UNO ANADOLU TAM BUĞD
UNO ANADOLU TAM BUĞD
MİS YOĞURT YARIM YAĞ
LS SOK MARKETLER TÍC.A.S
8718 ANTALYA KEPEZ BİLIM SANAT
EKÜ NO:0001
GARANTİ BBVA
************6650
KÜLTÜR MH 3847 SK
NO 7 6
KEPEZ ANTALYA
8140131899
ANADOLU KURUMLAR V.D
: 16/10/2026
:19:29:16let
:0438NeR
KASİYER: B****** Gk*
MERSIS : 0814013189988099
I:3646666
16/10/2026-19:29
üye Kart No : 5005000200017942
AID:A0000000031010
VER:SBOTB8DU UP:000000F
DO
%01
%01
%20
%01
%01
%01
*17,95
*49029 R. No:8718002490292610161925
*49,95
*1,00
*43,00
*43,00
*139,00
*3,07
*293,90
*293,90
Z NO:0219
T:04647396
8:000325 S:019380
APP.LABEL:VISA CREDIT
''';
