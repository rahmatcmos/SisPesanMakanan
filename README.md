# SisPesanMakanan
Sistem Pemesanan Makanan (SPM) berbasis Java/JSP dengan melibatkan fitur GIS (Google Maps API) ini dibuat untuk mempercepat pengantaran makanan ke pelanggan. Lamanya pengantaran pada pemesanan makanan online biasanya disebabkan pengantar tidak mengetahui secara pasti lokasi pelanggan. Solusinya adalah dengan mengikutsertakan fitur GIS yang bisa diakses oleh pengantar makanan.(URL web: http://sispesanmakanan.github.io/SisPesanMakanan/).

# Perangkat Lunak Pengembangan
1. IDE: NetBeans IDE 8.0.2 (Build 201411181905). Updates: Updates available to version NetBeans 8.0.2 Patch 2.
2. Java: 1.8.0_20; Java HotSpot(TM) Client VM 25.20-b23. Runtime: Java(TM) SE Runtime Environment 1.8.0_20-b26.
3. Webserver Apache Tomcat (di-bundle bersama NetBeans).
4. RDBMS MySQL. Bila menggunakan Windows bisa menggunakan MySQL bawaan XAMP sedangkan di Linux bisa menggunakan MariaDB. 
5. OS: Windows 7 version 6.1 running on x86; Cp1252; en_US (nb) / varian Linux (OpenSuSE, Ubuntu, dsb.).
6. Browser: Mozilla Firefox versi 21+.

# API Peta/GIS
1. Tampilan peta mengandalkan API dari layanan Google Maps sehingga saat pengembangan modul tertentu yang menampilkan peta maka harus terhubung dengan Internet.

# Parameter Koneksi Basisdata
1. Path berkas: web/pilar/konf/basisdata/basisdataKonf.xml
2. URL: https://github.com/SisPesanMakanan/SisPesanMakanan/blob/master/web/pilar/konf/basisdata/basisdataKonf.xml

# Parameter Direktori Sistem
1. Path berkas: src/java/pilar/cls/ClsKonf.java
2. URL: https://github.com/SisPesanMakanan/SisPesanMakanan/blob/master/src/java/pilar/cls/ClsKonf.java

# Informasi Login
1. Untuk login sebagai admin, klik gambar pengantar di pojok kiri atas maka halaman akan beralih ke halaman login admin. Masukkan id: "admin" dan sandi: "sandi" (untuk captcha case sensitive).
2. Untuk login sebagai operator, klik gambar pengantar di pojok kiri atas maka halaman akan beralih ke halaman login admin. Selanjutnya pada halaman login admin, klik kata "Administrator" maka halaman akan beralih ke halaman login operator. Untuk login operator kata sandinya adalah "sandi" sedangkan id-nya bisa bisa menggunakan salah satu dari berikut: OPMX7DY6, OPSXER58, atau OPEXMTFG (penerima pesanan, juru masak, atau pengantar).

Ok, demikian dan selamat mengembangkan lebih lanjut! :-)
