-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.21 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.1.0.4920
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for dbsispesanan
CREATE DATABASE IF NOT EXISTS `dbsispesanan` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dbsispesanan`;


-- Dumping structure for table dbsispesanan.tb_admin
CREATE TABLE IF NOT EXISTS `tb_admin` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(128) NOT NULL,
  `sandi` varchar(128) NOT NULL,
  `kode_karyawan` varchar(16) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_karyawan_UNIQUE` (`kode_karyawan`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  UNIQUE KEY `sandi_UNIQUE` (`sandi`),
  KEY `admin_kode_karyawan` (`kode_karyawan`),
  CONSTRAINT `admin_kode_karyawan` FOREIGN KEY (`kode_karyawan`) REFERENCES `tb_karyawan` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_admin: ~1 rows (approximately)
DELETE FROM `tb_admin`;
/*!40000 ALTER TABLE `tb_admin` DISABLE KEYS */;
INSERT INTO `tb_admin` (`nomor`, `nama`, `sandi`, `kode_karyawan`) VALUES
	(1, '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'KRY0000000000001');
/*!40000 ALTER TABLE `tb_admin` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_banner
CREATE TABLE IF NOT EXISTS `tb_banner` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `judul` varchar(45) DEFAULT NULL,
  `foto` varchar(32) DEFAULT NULL,
  `catatan` text,
  `tanggal` date DEFAULT NULL,
  `jam` time DEFAULT NULL,
  `status_depan` varchar(1) DEFAULT NULL,
  `kode_berita` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `banner_kode_berita` (`kode_berita`),
  CONSTRAINT `banner_kode_berita` FOREIGN KEY (`kode_berita`) REFERENCES `tb_berita` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_banner: ~0 rows (approximately)
DELETE FROM `tb_banner`;
/*!40000 ALTER TABLE `tb_banner` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_banner` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_berita
CREATE TABLE IF NOT EXISTS `tb_berita` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `judul` varchar(64) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam` time DEFAULT NULL,
  `isi` text,
  `operator` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `berita_kode_karyawan_admin` (`operator`),
  CONSTRAINT `berita_kode_karyawan_admin` FOREIGN KEY (`operator`) REFERENCES `tb_admin` (`kode_karyawan`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_berita: ~0 rows (approximately)
DELETE FROM `tb_berita`;
/*!40000 ALTER TABLE `tb_berita` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_berita` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_faktur_jual
CREATE TABLE IF NOT EXISTS `tb_faktur_jual` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `pajak` varchar(10) NOT NULL,
  `biaya_antar` varchar(10) NOT NULL,
  `total` varchar(10) NOT NULL,
  `kode_orang` varchar(16) NOT NULL,
  `kode_metode_pesan` varchar(8) NOT NULL,
  `kode_metode_bayar` varchar(8) NOT NULL,
  `status_pesanan` varchar(1) NOT NULL,
  `status_bayar` varchar(1) NOT NULL,
  `catatan` text NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `waktu` varchar(5) NOT NULL,
  `timestamp` varchar(128) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `faktur_jual_nama_operator` (`status_pesanan`),
  KEY `faktur_jual_kode_pelanggan` (`kode_orang`),
  KEY `faktur_jual_kode_metode_bayar` (`kode_metode_bayar`),
  KEY `faktur_jual_kode_metode_pesan` (`kode_metode_pesan`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_faktur_jual: ~3 rows (approximately)
DELETE FROM `tb_faktur_jual`;
/*!40000 ALTER TABLE `tb_faktur_jual` DISABLE KEYS */;
INSERT INTO `tb_faktur_jual` (`nomor`, `kode`, `pajak`, `biaya_antar`, `total`, `kode_orang`, `kode_metode_pesan`, `kode_metode_bayar`, `status_pesanan`, `status_bayar`, `catatan`, `tanggal`, `waktu`, `timestamp`) VALUES
	(1, 'FKYFSGFGYPH4K414', '10300.0', '13000', '126300.0', 'ORP5G8T5KBUEQ5EU', '', '', '3', '0', '', '2015-06-12', '12:11', '1434085879'),
	(2, 'FKWSSNU8XBZH9CSR', '10300.0', '13000', '126300.0', 'ORP5G8T5KBUEQ5EU', '', '', '3', '0', '', '2015-06-12', '12:54', '1434088465'),
	(3, 'FKXVH4AUTQU3BFAC', '4800.0', '13000', '65800.0', 'ORP5G8T5KBUEQ5EU', '', '', '3', '0', '', '2015-06-12', '14:16', '1434093363');
/*!40000 ALTER TABLE `tb_faktur_jual` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_fin_mata_uang
CREATE TABLE IF NOT EXISTS `tb_fin_mata_uang` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `singkatan` varchar(4) NOT NULL,
  `kode_geo_negara` varchar(8) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_fin_mata_uang: ~2 rows (approximately)
DELETE FROM `tb_fin_mata_uang`;
/*!40000 ALTER TABLE `tb_fin_mata_uang` DISABLE KEYS */;
INSERT INTO `tb_fin_mata_uang` (`nomor`, `kode`, `nama`, `singkatan`, `kode_geo_negara`, `catatan`) VALUES
	(1, 'MUZMDXYV', 'Rupiah', 'Rp', 'NGUMARQ5', ''),
	(2, 'MUNNTN0R', 'Yen', '¥', 'NGKJXHGC', '');
/*!40000 ALTER TABLE `tb_fin_mata_uang` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_foto_orang
CREATE TABLE IF NOT EXISTS `tb_foto_orang` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) NOT NULL,
  `nama` varchar(45) NOT NULL,
  `status_depan` varchar(1) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `foto_orang_kode_orang` (`kode_orang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_foto_orang: ~0 rows (approximately)
DELETE FROM `tb_foto_orang`;
/*!40000 ALTER TABLE `tb_foto_orang` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_foto_orang` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_foto_produk
CREATE TABLE IF NOT EXISTS `tb_foto_produk` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_produk` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  `status_depan` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `foto_produk_kode_produk` (`kode_produk`),
  CONSTRAINT `foto_produk_kode_produk` FOREIGN KEY (`kode_produk`) REFERENCES `tb_resto_produk` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_foto_produk: ~0 rows (approximately)
DELETE FROM `tb_foto_produk`;
/*!40000 ALTER TABLE `tb_foto_produk` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_foto_produk` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_geo_jalan
CREATE TABLE IF NOT EXISTS `tb_geo_jalan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  `kode_geo_negara` varchar(8) NOT NULL,
  `kode_geo_provinsi` varchar(8) NOT NULL,
  `kode_geo_kabupaten` varchar(8) NOT NULL,
  `kode_geo_kecamatan` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `geo_jalan_kode_kecamatan` (`kode_geo_kecamatan`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_geo_jalan: ~2 rows (approximately)
DELETE FROM `tb_geo_jalan`;
/*!40000 ALTER TABLE `tb_geo_jalan` DISABLE KEYS */;
INSERT INTO `tb_geo_jalan` (`nomor`, `kode`, `nama`, `catatan`, `kode_geo_negara`, `kode_geo_provinsi`, `kode_geo_kabupaten`, `kode_geo_kecamatan`) VALUES
	(1, 'JLPMHWGX', 'Margonda X', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED', 'KCZBM90Y'),
	(2, 'JLCH6FXH', 'K. H. Ahmad Dahlan', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2', 'KCAJK8ES');
/*!40000 ALTER TABLE `tb_geo_jalan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_geo_kabupaten
CREATE TABLE IF NOT EXISTS `tb_geo_kabupaten` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(45) NOT NULL,
  `catatan` text,
  `kode_geo_negara` varchar(8) NOT NULL,
  `kode_geo_provinsi` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `geo_kabupaten_kode_provinsi` (`kode_geo_negara`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_geo_kabupaten: ~133 rows (approximately)
DELETE FROM `tb_geo_kabupaten`;
/*!40000 ALTER TABLE `tb_geo_kabupaten` DISABLE KEYS */;
INSERT INTO `tb_geo_kabupaten` (`nomor`, `kode`, `nama`, `catatan`, `kode_geo_negara`, `kode_geo_provinsi`) VALUES
	(6, 'KBQMFYB2', 'Depok', '', 'NGUMARQ5', 'PVURVMN5'),
	(7, 'KBQQGWWX', 'Indramayu', '', 'NGUMARQ5', 'PVURVMN5'),
	(8, 'KB9G0CX8', 'Tabanan', '', 'NGUMARQ5', 'PVHGUWC8'),
	(9, 'KB1HHE4J', 'Negara', '', 'NGUMARQ5', 'PVHGUWC8'),
	(10, 'KBHYACN2', 'Badung', '', 'NGUMARQ5', 'PVHGUWC8'),
	(11, 'KBSF2HWD', 'Denpasar', '', 'NGUMARQ5', 'PVHGUWC8'),
	(12, 'KBF1QUZJ', 'Singaraja', '', 'NGUMARQ5', 'PVHGUWC8'),
	(13, 'KBJQTJAW', 'Makassar', '', 'NGUMARQ5', 'PVJKDRFY'),
	(14, 'KBKEEUEU', 'Bantaeng', '', 'NGUMARQ5', 'PVJKDRFY'),
	(15, 'KB6EDBZ9', 'Barru', '', 'NGUMARQ5', 'PVJKDRFY'),
	(16, 'KBH7U90R', 'Bone', '', 'NGUMARQ5', 'PVJKDRFY'),
	(17, 'KBHAHMG9', 'Bulukumba', '', 'NGUMARQ5', 'PVJKDRFY'),
	(18, 'KBDX1CWV', 'Enrekang', '', 'NGUMARQ5', 'PVJKDRFY'),
	(19, 'KBR66WNA', 'Gowa', '', 'NGUMARQ5', 'PVJKDRFY'),
	(20, 'KBXJRJCU', 'Jenponto', '', 'NGUMARQ5', 'PVJKDRFY'),
	(21, 'KBXT3A75', 'Kepulauan Selayar', '', 'NGUMARQ5', 'PVJKDRFY'),
	(22, 'KBWTXWF1', 'Luwu', '', 'NGUMARQ5', 'PVJKDRFY'),
	(23, 'KB5DPTK7', 'Luwu Timur', '', 'NGUMARQ5', 'PVJKDRFY'),
	(24, 'KBFTTGW1', 'Luwu Utara', '', 'NGUMARQ5', 'PVJKDRFY'),
	(25, 'KBDZXFBM', 'Maros', '', 'NGUMARQ5', 'PVJKDRFY'),
	(26, 'KBXNDN5H', 'Pangkajene dan Kepulauan', '', 'NGUMARQ5', 'PVJKDRFY'),
	(27, 'KBPUERFZ', 'Pinrang', '', 'NGUMARQ5', 'PVJKDRFY'),
	(28, 'KBTKUQXW', 'Sidenreng Rappang', '', 'NGUMARQ5', 'PVJKDRFY'),
	(29, 'KB1QMEFK', 'Sinjai', '', 'NGUMARQ5', 'PVJKDRFY'),
	(30, 'KBBCMRQP', 'Soppeng', '', 'NGUMARQ5', 'PVJKDRFY'),
	(31, 'KB0WXB3C', 'Takalar', '', 'NGUMARQ5', 'PVJKDRFY'),
	(32, 'KBBJDC1P', 'Tana Toraja', '', 'NGUMARQ5', 'PVJKDRFY'),
	(33, 'KBN3TTMZ', 'Toraja Utara', '', 'NGUMARQ5', 'PVJKDRFY'),
	(34, 'KBQEQZ47', 'Wajo', '', 'NGUMARQ5', 'PVJKDRFY'),
	(35, 'KBZ98SAP', 'Palopo', '', 'NGUMARQ5', 'PVJKDRFY'),
	(36, 'KB2TTSTP', 'Parepare', '', 'NGUMARQ5', 'PVJKDRFY'),
	(37, 'KB4RADQW', 'Bandung', '', 'NGUMARQ5', 'PVURVMN5'),
	(38, 'KBCGCHXW', 'Banjar', '', 'NGUMARQ5', 'PVURVMN5'),
	(39, 'KBFN7WAN', 'Bekasi', '', 'NGUMARQ5', 'PVURVMN5'),
	(40, 'KBS9C04M', 'Bogor', '', 'NGUMARQ5', 'PVURVMN5'),
	(41, 'KBZB4MAX', 'Cimahi', '', 'NGUMARQ5', 'PVURVMN5'),
	(42, 'KBQK589J', 'Cirebon', '', 'NGUMARQ5', 'PVURVMN5'),
	(43, 'KBBTGTSH', 'Sukabumi', '', 'NGUMARQ5', 'PVURVMN5'),
	(44, 'KBXRSQY8', 'Tasikmalaya', '', 'NGUMARQ5', 'PVURVMN5'),
	(45, 'KBRNEKM5', 'Bandung Kota', '', 'NGUMARQ5', 'PVURVMN5'),
	(46, 'KB0R3QQW', 'Kota Banjar', '', 'NGUMARQ5', 'PVURVMN5'),
	(47, 'KBG5GRTS', 'Kota Bekasi', '', 'NGUMARQ5', 'PVURVMN5'),
	(48, 'KBNMUVQ4', 'Kota Bogor', '', 'NGUMARQ5', 'PVURVMN5'),
	(49, 'KBCX5FAW', 'Kota Cimahi', '', 'NGUMARQ5', 'PVURVMN5'),
	(50, 'KBPMGZFC', 'Kota Cirebon', '', 'NGUMARQ5', 'PVURVMN5'),
	(51, 'KBHVDEG5', 'Kota Sukabumi', '', 'NGUMARQ5', 'PVURVMN5'),
	(52, 'KBUXRFRE', 'Garut', '', 'NGUMARQ5', 'PVURVMN5'),
	(53, 'KBA3SCD0', 'Karawang', '', 'NGUMARQ5', 'PVURVMN5'),
	(54, 'KBKCRMM2', 'Kuningan', '', 'NGUMARQ5', 'PVURVMN5'),
	(55, 'KBPRPKKB', 'Majalengka', '', 'NGUMARQ5', 'PVURVMN5'),
	(56, 'KBU7XMUD', 'Pangandaran', '', 'NGUMARQ5', 'PVURVMN5'),
	(57, 'KBGNEAAR', 'Purwakarta', '', 'NGUMARQ5', 'PVURVMN5'),
	(58, 'KBPZM9RC', 'Subang', '', 'NGUMARQ5', 'PVURVMN5'),
	(59, 'KBEMPXE3', 'Sumedang', '', 'NGUMARQ5', 'PVURVMN5'),
	(60, 'KBKDQUCW', 'Bandung Barat', '', 'NGUMARQ5', 'PVURVMN5'),
	(61, 'KBHJC5VS', 'Banyuasin', '', 'NGUMARQ5', 'PVXWTU6S'),
	(62, 'KB8WE68Q', 'Empat Lawang', '', 'NGUMARQ5', 'PVXWTU6S'),
	(63, 'KBQHJUUN', 'Lahat', '', 'NGUMARQ5', 'PVXWTU6S'),
	(64, 'KBQDET36', 'Muara Enim', '', 'NGUMARQ5', 'PVXWTU6S'),
	(65, 'KBZX1VRV', 'Musi Banyuasin', '', 'NGUMARQ5', 'PVXWTU6S'),
	(66, 'KB8SSS5B', 'Musi Rawas', '', 'NGUMARQ5', 'PVXWTU6S'),
	(67, 'KBU6Y5BB', 'Musi Rawas Utara', '', 'NGUMARQ5', 'PVXWTU6S'),
	(68, 'KBKZ0HUS', 'Ogan Ilir', '', 'NGUMARQ5', 'PVXWTU6S'),
	(69, 'KB8BADFS', 'Ogan Komering Ilir', '', 'NGUMARQ5', 'PVXWTU6S'),
	(70, 'KBG0VKZZ', 'Ogan Komering Ulu', '', 'NGUMARQ5', 'PVXWTU6S'),
	(71, 'KBAADPMK', 'Ogan Komering Ulu Selatan', '', 'NGUMARQ5', 'PVXWTU6S'),
	(72, 'KBAFV0DF', 'Penukal Abab Lematang Ilir', '', 'NGUMARQ5', 'PVXWTU6S'),
	(73, 'KBJT9PKW', 'Ogan Komering Ulu Timur', '', 'NGUMARQ5', 'PVXWTU6S'),
	(74, 'KBP3GPDB', 'Kota Lubuklinggau', '', 'NGUMARQ5', 'PVXWTU6S'),
	(75, 'KBGAPWGC', 'Kota Pagar Alam', '', 'NGUMARQ5', 'PVXWTU6S'),
	(76, 'KBFKZ64W', 'Kota Palembang', '', 'NGUMARQ5', 'PVXWTU6S'),
	(77, 'KBZVJJNG', 'Kota Prabumulih', '', 'NGUMARQ5', 'PVXWTU6S'),
	(78, 'KBQRARSE', 'Agam', '', 'NGUMARQ5', 'PV5PRUFG'),
	(79, 'KBWPAD4Q', 'Dharmasraya', '', 'NGUMARQ5', 'PV5PRUFG'),
	(80, 'KBC4FBSF', 'Kepulauan Mentawai', '', 'NGUMARQ5', 'PV5PRUFG'),
	(81, 'KBCC8MM6', 'Lima Puluh Kota', '', 'NGUMARQ5', 'PV5PRUFG'),
	(82, 'KB5ZUHYZ', 'Padang Pariaman', '', 'NGUMARQ5', 'PV5PRUFG'),
	(83, 'KBBKAEGC', 'Pasaman', '', 'NGUMARQ5', 'PV5PRUFG'),
	(84, 'KB4EZBWM', 'Pasaman Barat', '', 'NGUMARQ5', 'PV5PRUFG'),
	(85, 'KBYH89AK', 'Pesisir Selatan', '', 'NGUMARQ5', 'PV5PRUFG'),
	(86, 'KB1QBKD2', 'Sijunjung', '', 'NGUMARQ5', 'PV5PRUFG'),
	(87, 'KBV2FZM1', 'Solok', '', 'NGUMARQ5', 'PV5PRUFG'),
	(88, 'KBYBRXB3', 'Solok Selatan', '', 'NGUMARQ5', 'PV5PRUFG'),
	(89, 'KBJPBA2V', 'Tanah Datar', '', 'NGUMARQ5', 'PV5PRUFG'),
	(90, 'KB33Z1YQ', 'Bukittinggi', '', 'NGUMARQ5', 'PV5PRUFG'),
	(91, 'KBQSKQGX', 'Kota Padang', '', 'NGUMARQ5', 'PV5PRUFG'),
	(92, 'KB3B3CDD', 'Kota Padangpanjang', '', 'NGUMARQ5', 'PV5PRUFG'),
	(93, 'KBQMUCTC', 'Kota Pariaman', '', 'NGUMARQ5', 'PV5PRUFG'),
	(94, 'KBKDFCQT', 'Kota Payakumbuh', '', 'NGUMARQ5', 'PV5PRUFG'),
	(95, 'KBUAPTRD', 'Kota Swahlunto', '', 'NGUMARQ5', 'PV5PRUFG'),
	(96, 'KBKYWJ6P', 'Kota Solok', '', 'NGUMARQ5', 'PV5PRUFG'),
	(97, 'KBEYE7W0', 'Bima', '', 'NGUMARQ5', 'PVCRASKA'),
	(98, 'KBH3CM98', 'Dompu', '', 'NGUMARQ5', 'PVCRASKA'),
	(99, 'KBW3Q2GK', 'Lombok Barat', '', 'NGUMARQ5', 'PVCRASKA'),
	(100, 'KBWZ3VGZ', 'Lombok Tengah', '', 'NGUMARQ5', 'PVCRASKA'),
	(101, 'KB3KAPBM', 'Lombok Timur', '', 'NGUMARQ5', 'PVCRASKA'),
	(102, 'KBXTX19Y', 'Lombok Utara', '', 'NGUMARQ5', 'PVCRASKA'),
	(103, 'KBY7C3PX', 'Sumbawa', '', 'NGUMARQ5', 'PVCRASKA'),
	(104, 'KBHSW446', 'Sumbawa Barat', '', 'NGUMARQ5', 'PVCRASKA'),
	(105, 'KBVU4NSW', 'Kota Bima', '', 'NGUMARQ5', 'PVCRASKA'),
	(106, 'KBV8YSXZ', 'Kota Mataram', '', 'NGUMARQ5', 'PVCRASKA'),
	(107, 'KBFWV0HW', 'Banjarnegara', '', 'NGUMARQ5', 'PVBXY4BH'),
	(108, 'KBZ21MCX', 'Banyumas', '', 'NGUMARQ5', 'PVBXY4BH'),
	(109, 'KB0Y3GHK', 'Batang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(110, 'KBZ2XFMX', 'Blora', '', 'NGUMARQ5', 'PVBXY4BH'),
	(111, 'KBGXAAES', 'Boyolali', '', 'NGUMARQ5', 'PVBXY4BH'),
	(112, 'KBABBGGK', 'Brebes', '', 'NGUMARQ5', 'PVBXY4BH'),
	(113, 'KB9XWKC3', 'Cilacap', '', 'NGUMARQ5', 'PVBXY4BH'),
	(114, 'KBYUNPAM', 'Demak', '', 'NGUMARQ5', 'PVBXY4BH'),
	(115, 'KBE81DB8', 'Grobogan', '', 'NGUMARQ5', 'PVBXY4BH'),
	(116, 'KBUDEQT4', 'Jepara', '', 'NGUMARQ5', 'PVBXY4BH'),
	(117, 'KBJWAAHP', 'Karanganyar', '', 'NGUMARQ5', 'PVBXY4BH'),
	(118, 'KBUMR7C2', 'Kebumen', '', 'NGUMARQ5', 'PVBXY4BH'),
	(119, 'KBRYNKYP', 'Kendal', '', 'NGUMARQ5', 'PVBXY4BH'),
	(120, 'KBKKGG9C', 'Klaten', '', 'NGUMARQ5', 'PVBXY4BH'),
	(121, 'KBQ4PUQ9', 'Kudus', '', 'NGUMARQ5', 'PVBXY4BH'),
	(122, 'KBDJQAPD', 'Magelang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(123, 'KBPYE1W1', 'Pati', '', 'NGUMARQ5', 'PVBXY4BH'),
	(124, 'KBXRADHG', 'Pekalongan', '', 'NGUMARQ5', 'PVBXY4BH'),
	(125, 'KBADNMZF', 'Pemalang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(126, 'KBYHPBEY', 'Purbalingga', '', 'NGUMARQ5', 'PVBXY4BH'),
	(127, 'KBXH0DNS', 'Purworejo', '', 'NGUMARQ5', 'PVBXY4BH'),
	(128, 'KBSZEPW1', 'Rembang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(129, 'KB4TSQED', 'Semarang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(130, 'KBTPJCBG', 'Sragen', '', 'NGUMARQ5', 'PVBXY4BH'),
	(131, 'KBF102QP', 'Sukoharjo', '', 'NGUMARQ5', 'PVBXY4BH'),
	(132, 'KBUCNBGD', 'Temanggung', '', 'NGUMARQ5', 'PVBXY4BH'),
	(133, 'KBYJZXP6', 'Wonogiri', '', 'NGUMARQ5', 'PVBXY4BH'),
	(134, 'KBCJWVSP', 'Wonosobo', '', 'NGUMARQ5', 'PVBXY4BH'),
	(135, 'KBGDZ9KV', 'Kota Magelang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(136, 'KBPQYYV0', 'Kota Pekalongan', '', 'NGUMARQ5', 'PVBXY4BH'),
	(137, 'KB933FWN', 'Kota Salatiga', '', 'NGUMARQ5', 'PVBXY4BH'),
	(138, 'KB1S4HAT', 'Kota Semarang', '', 'NGUMARQ5', 'PVBXY4BH'),
	(139, 'KB5ZE7VP', 'Kota Kartasura', '', 'NGUMARQ5', 'PVBXY4BH'),
	(140, 'KBG8FXBK', 'Kota Tegal', '', 'NGUMARQ5', 'PVBXY4BH');
/*!40000 ALTER TABLE `tb_geo_kabupaten` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_geo_kecamatan
CREATE TABLE IF NOT EXISTS `tb_geo_kecamatan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  `kode_geo_negara` varchar(8) NOT NULL,
  `kode_geo_provinsi` varchar(8) NOT NULL,
  `kode_geo_kabupaten` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `geo_kecamatan_kode_kabupaten` (`kode_geo_negara`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_geo_kecamatan: ~121 rows (approximately)
DELETE FROM `tb_geo_kecamatan`;
/*!40000 ALTER TABLE `tb_geo_kecamatan` DISABLE KEYS */;
INSERT INTO `tb_geo_kecamatan` (`nomor`, `kode`, `nama`, `catatan`, `kode_geo_negara`, `kode_geo_provinsi`, `kode_geo_kabupaten`) VALUES
	(2, 'KCYZU4GU', 'Beji', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(3, 'KCR6PDNE', 'Sawangan', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(4, 'KCFB3KHJ', 'Bojongsari', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(5, 'KCRHR45U', 'Pancoran Mas', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(6, 'KCHRA6BW', 'Cipayung', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(7, 'KC9TGZNZ', 'Sukma Jaya', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(8, 'KCF3N0XT', 'Cilodong', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(9, 'KCWNCQFP', 'Cimanggis', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(10, 'KCM3VNF8', 'Tapos', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(12, 'KCNMUYWG', 'Limo', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(13, 'KCXG9R25', 'Cinere', '', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2'),
	(14, 'KCXXNBYM', 'Mariso', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(15, 'KCFBZEK4', 'Mamajang', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(16, 'KC4JQQAM', 'Tamalate', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(17, 'KCJAVEVM', 'Rappocini', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(18, 'KCCBRFGQ', 'Makassar', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(19, 'KCUEVHBK', 'Ujung Pandang', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(20, 'KCQQEEFC', 'Wajo', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(21, 'KCUHQR61', 'Bontoala', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(22, 'KCQDT1KB', 'Ujung Tanah', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(23, 'KCDW2882', 'Tallo', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(24, 'KCJWCSEK', 'Panukkukang', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(25, 'KCUBDXTT', 'Manggala', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(26, 'KCKCTDAW', 'Biring Kanaya', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(27, 'KC4MZSDS', 'Tamalanrea', '', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW'),
	(28, 'KC3JV8YP', 'Jatisampura', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(29, 'KC7D9CBA', 'Pondok Melati', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(30, 'KCKMUHNE', 'Jatiasih', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(31, 'KCTDJC8W', 'Bantargebang', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(32, 'KCFFKGDJ', 'Mustikajaya', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(33, 'KCHGVB1M', 'Bekasi Timur', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(34, 'KCTZQCWS', 'Rawalumbu', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(35, 'KCWDXFR1', 'Bekasi Selatan', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(36, 'KCVH58UU', 'Bekasi Barat', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(37, 'KCF7KBKE', 'Medan Satria', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(38, 'KCCWBZHY', 'Bekasi Utara', '', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS'),
	(39, 'KCJ4FJ35', 'Setu', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(40, 'KCB0PYUR', 'Serang Baru', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(41, 'KCSWZ99N', 'Cikarang Pusat', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(42, 'KCYRM83Z', 'Cikarang Selatan', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(43, 'KCNDGE3X', 'Ciburusah', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(44, 'KCAUNXVA', 'Bojongmangu', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(45, 'KCG0GNU1', 'Cikarang Timur', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(46, 'KCRNWBXQ', 'Kedungwaringin', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(47, 'KC1XMZK9', 'Cikarang Utara', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(48, 'KCH8AKJE', 'Karangbahagia', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(49, 'KC3W40DM', 'Cibitung', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(50, 'KCWM2AMP', 'Cikarang Barat', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(51, 'KC8QR3KG', 'Tambun Selatan', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(52, 'KC6MGMS6', 'Tambun Utara', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(53, 'KCWR5YPX', 'Babelan', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(54, 'KCWAUBUQ', 'Tarumajaya', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(55, 'KCZMBZKP', 'Tambelang', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(56, 'KCBGVD3M', 'Sukawangi', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(57, 'KCA3NHKX', 'Sukatani', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(58, 'KCBRGVBB', 'Sukakarya', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(59, 'KCWYYFPJ', 'Pebayuran', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(60, 'KC1XXXZX', 'Cabangbungin', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(61, 'KCJ0QRBZ', 'Muara Gembong', '', 'NGUMARQ5', 'PVURVMN5', 'KBFN7WAN'),
	(62, 'KCGBW7DS', 'Baturiti', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(63, 'KCXDW7AW', 'Kediri', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(64, 'KCTAFNCB', 'Kerambitan', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(65, 'KCPQ84ZV', 'Marga', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(66, 'KCWH78E7', 'Penebel', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(67, 'KC9GZ5MG', 'Pupuan', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(68, 'KCDQM0A8', 'Selemadeg', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(69, 'KCWTDYNX', 'Selemadeg Barat', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(70, 'KCWXREQ3', 'Selemadeg Timur', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(71, 'KCXBJNHY', 'Tabanan', '', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8'),
	(72, 'KC6XDKKE', 'Petang', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(73, 'KCEUUGFX', 'Abiansemal', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(74, 'KCFZMT7Y', 'Mengwi', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(75, 'KCAS4FAZ', 'Kuta', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(76, 'KCN3MEVW', 'Kuta Utara', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(77, 'KCXMKPQK', 'Kuta Selatan', '', 'NGUMARQ5', 'PVHGUWC8', 'KBHYACN2'),
	(78, 'KCUHXQHN', 'Batukliang Utara', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(79, 'KCR6UEZF', 'Batukliang', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(80, 'KCDS9ZHF', 'Janapria', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(81, 'KCQE4QQ5', 'Jonggat', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(82, 'KCPS5YA0', 'Kopang', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(83, 'KCGZPMRB', 'Praya Barat Daya', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(84, 'KCTVJ05E', 'Praya Barat', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(85, 'KCKZTARE', 'Praya Tengah', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(86, 'KC9B38RZ', 'Praya Timur', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(87, 'KCZFG2ET', 'Praya', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(88, 'KCEX9PRP', 'Pringgarata', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(89, 'KCHZFGDZ', 'Pujut', '', 'NGUMARQ5', 'PVCRASKA', 'KBWZ3VGZ'),
	(95, 'KCFC9WGS', 'Ungaran Barat', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(96, 'KCAT4S7X', 'Ungaran Timur', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(97, 'KCAJEXQF', 'Bergas', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(98, 'KCJZZDTZ', 'Pringapus', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(99, 'KCHMBWHD', 'Bawen', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(100, 'KCGDJFEP', 'Bringin', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(101, 'KCSBSNJS', 'Tuntang', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(102, 'KC4C1DHM', 'Pabelan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(103, 'KCT06FHT', 'Bancak', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(104, 'KC5XPKVR', 'Suruh', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(105, 'KCEQDTJD', 'Susukan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(106, 'KCJ14G8S', 'Kaliwungu', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(107, 'KCDYNN4D', 'Tengaran', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(108, 'KCUDJNSA', 'Getasan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(109, 'KCZBM90Y', 'Banyubiru', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(110, 'KC3SJR2Y', 'Sumowono', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(111, 'KCWEYQQP', 'Ambarawa', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(112, 'KCUAQT4S', 'Jambu', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(113, 'KC3NFBU1', 'Bandungan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB4TSQED'),
	(114, 'KCG9QAP8', 'Banyumanik', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(115, 'KC0JGVUA', 'Candisari', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(116, 'KCAV0HGM', 'Gajahmungkur', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(117, 'KCBQN10D', 'Gayamsari', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(118, 'KCNZNT58', 'Genuk', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(119, 'KCK52QXA', 'Gunungpati', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(120, 'KC25YJAF', 'Mijen', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(121, 'KCBE8ECD', 'Ngaliyan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(122, 'KCGHXVAV', 'Pedurungan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(123, 'KCUFXGWA', 'Semarang Barat', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(124, 'KCAXCUYZ', 'Semarang Selatan', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(125, 'KC2ZJJKT', 'Semarang Tengah', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(126, 'KCNK4DFD', 'Semarang Timur', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(127, 'KC3JZZQT', 'Semarang Utara', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(128, 'KCHRAHXA', 'Tembalang', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT'),
	(129, 'KCNKZ5D9', 'Tugu', '', 'NGUMARQ5', 'PVBXY4BH', 'KB1S4HAT');
/*!40000 ALTER TABLE `tb_geo_kecamatan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_geo_negara
CREATE TABLE IF NOT EXISTS `tb_geo_negara` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_geo_negara: ~6 rows (approximately)
DELETE FROM `tb_geo_negara`;
/*!40000 ALTER TABLE `tb_geo_negara` DISABLE KEYS */;
INSERT INTO `tb_geo_negara` (`nomor`, `kode`, `nama`, `catatan`) VALUES
	(8, 'NGVWGPPQ', 'Malaysia', 'Test'),
	(9, 'NGKJXHGC', 'Jepang', 'Test'),
	(10, 'NGC0HFD0', 'Australia', 'Test'),
	(11, 'NGQCDTTJ', 'Arab Saudi', 'Test'),
	(12, 'NGVD1V5W', 'Denmark', ''),
	(13, 'NGFYQ93C', 'Finlandia', ''),
	(14, 'NGUMARQ5', 'Indonesia', '');
/*!40000 ALTER TABLE `tb_geo_negara` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_geo_provinsi
CREATE TABLE IF NOT EXISTS `tb_geo_provinsi` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  `kode_geo_negara` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `geo_provinsi_kode_negara` (`kode_geo_negara`),
  CONSTRAINT `geo_provinsi_kode_negara` FOREIGN KEY (`kode_geo_negara`) REFERENCES `tb_geo_negara` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_geo_provinsi: ~8 rows (approximately)
DELETE FROM `tb_geo_provinsi`;
/*!40000 ALTER TABLE `tb_geo_provinsi` DISABLE KEYS */;
INSERT INTO `tb_geo_provinsi` (`nomor`, `kode`, `nama`, `catatan`, `kode_geo_negara`) VALUES
	(1, 'PVURVMN5', 'Jawa Barat', '', 'NGUMARQ5'),
	(2, 'PVQHFPJT', 'Jawa Timur', '', 'NGUMARQ5'),
	(3, 'PVXWTU6S', 'Sumatera Selatan', '', 'NGUMARQ5'),
	(4, 'PVJKDRFY', 'Sulawesi Selatan', '', 'NGUMARQ5'),
	(5, 'PVHGUWC8', 'Bali', '', 'NGUMARQ5'),
	(6, 'PVCRASKA', 'Nusa Tenggara Barat', '', 'NGUMARQ5'),
	(7, 'PV5PRUFG', 'Sumatera Barat', '', 'NGUMARQ5'),
	(8, 'PVBXY4BH', 'Jawa Tengah', '', 'NGUMARQ5');
/*!40000 ALTER TABLE `tb_geo_provinsi` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_banner
CREATE TABLE IF NOT EXISTS `tb_hlm_banner` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `judul` varchar(256) NOT NULL,
  `teks` text NOT NULL,
  `kode_foto` varchar(8) NOT NULL,
  `publikasi` varchar(1) NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) NOT NULL,
  `timestamp` varchar(64) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `kode` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_banner: ~7 rows (approximately)
DELETE FROM `tb_hlm_banner`;
/*!40000 ALTER TABLE `tb_hlm_banner` DISABLE KEYS */;
INSERT INTO `tb_hlm_banner` (`nomor`, `kode`, `judul`, `teks`, `kode_foto`, `publikasi`, `tanggal`, `jam`, `timestamp`) VALUES
	(3, 'BNDHP3HP', 'Ikan Mina Wangi', 'Menu pada bulan April ini sangat istimewa. <br>', 'test', '1', '2015-05-31', '10:01', '1433041271'),
	(4, 'BNF8FFAA', 'Nila Bakar', '', '', '1', '2015-05-31', '09:18', '1433038729'),
	(5, 'BNDPRQHE', 'Rendang', '', '', '1', '2015-05-31', '09:48', '1433040486'),
	(6, 'BN6B27TN', 'Udang Saus Tiram', '', '', '1', '2015-05-31', '10:08', '1433041680'),
	(7, 'BNH6KGCZ', 'Kepiting Saus Padang', '', '', '1', '2015-05-31', '10:13', '1433041990'),
	(8, 'BNHCNP9H', 'Nasi Rames Spesial', '', '', '1', '2015-05-31', '10:35', '1433043302'),
	(9, 'BN20NNHY', 'Gulai Tongkol', '', '', '1', '2015-05-31', '10:51', '1433044281');
/*!40000 ALTER TABLE `tb_hlm_banner` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_banner_foto
CREATE TABLE IF NOT EXISTS `tb_hlm_banner_foto` (
  `nomor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `nama_berkas` varchar(256) NOT NULL,
  `nama_berkas_asli` varchar(256) NOT NULL,
  `ekstensi` varchar(8) NOT NULL,
  `sampul` varchar(1) NOT NULL,
  `keterangan` text NOT NULL,
  `kode_hlm_banner` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_banner_foto: ~5 rows (approximately)
DELETE FROM `tb_hlm_banner_foto`;
/*!40000 ALTER TABLE `tb_hlm_banner_foto` DISABLE KEYS */;
INSERT INTO `tb_hlm_banner_foto` (`nomor`, `kode`, `nama`, `nama_berkas`, `nama_berkas_asli`, `ekstensi`, `sampul`, `keterangan`, `kode_hlm_banner`) VALUES
	(11, 'FP511KJNPGCP100A', 'Ikan Nila Bakar', 'F9PPRUeeTaZhtFMtGjgy9FKWc2D7Kb41avT83Ch5gbpEaYwMGaq9B9WD', 'ikan-nila-bakar-bumbu-padang.jpg', '.jpg', '1', '', 'BNF8FFAA'),
	(12, 'FPWZYDN2ZKVG2W5V', 'Ikan Mina Wangi', 'yk1tcE5FUPEvArGNtgSDr2Zg3J2nSArC8KVuNqvmspf8kKFxNj6EUCSa', 'ikanminawangi.jpg', '.jpg', '0', '', 'BNDHP3HP'),
	(14, 'FPEQDWPSTGYXSVSP', 'Kepiting Saus Padang', 'BPQQzFwj5Rn2jGgXpMvXmnnUufk6pY4FRFnB8C1GfbFRZdcuxxmJfvm8', '147_1_4-Photo.jpg', '.jpg', '1', '', 'BNH6KGCZ'),
	(15, 'FP6KSTGBFBQY0ZZG', 'Udang Saus Tiram', 'MypMvm107dsyeCZwnKHrz0bgQnDCdvT5Bq8vEutsrupMxgVRjM4a8mGH', 'DSC_0146.jpg', '.jpg', '1', '', 'BN6B27TN'),
	(16, 'FPSB9NY5RX88PYWY', 'Nasi Rames Spesial', '0sgUsyQQHYshdVUSkxTn0WNjEKaz92n1Xz0qwBK1wegntyR61xjrHE5V', 'GL-Travel-WM.M.L-09.jpg', '.jpg', '1', '', 'BNHCNP9H'),
	(17, 'FPFKXZXYUNBRBXK2', 'Gulai Tongkol Asam Padeh', 'VektTZxpwTdha8A0UJ43rXEJ3UDus1TTb3WqdcjTErjwA52y17t7vTQe', 'Resep Gulai Ikan Tongkol Asam Padeh Khas Padang yang Lezat.jpg', '.jpg', '1', '', 'BN20NNHY');
/*!40000 ALTER TABLE `tb_hlm_banner_foto` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_berita
CREATE TABLE IF NOT EXISTS `tb_hlm_berita` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `judul` varchar(256) NOT NULL,
  `teks` text NOT NULL,
  `kode_foto` varchar(8) NOT NULL,
  `publikasi` varchar(1) NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) NOT NULL,
  `timestamp` varchar(64) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `kode` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_berita: ~0 rows (approximately)
DELETE FROM `tb_hlm_berita`;
/*!40000 ALTER TABLE `tb_hlm_berita` DISABLE KEYS */;
INSERT INTO `tb_hlm_berita` (`nomor`, `kode`, `judul`, `teks`, `kode_foto`, `publikasi`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'BTVPEENT', 'Kunjungan ke Panti Asuhan "Al Taqwa"', 'Pada hari ini kami, keluarga besar RMP Sederhana mengadakan kunjungan ke Panti Asuhan "Al Taqwa". <br>', 'Test', '0', '2015-05-29', '14:11', '1432883468'),
	(2, 'BTHSV1SU', 'Perayaan 5 Tahun Berdirinya RM Padang', 'Pada Minggu, 09 Mei 2015, berlangsung acara perayaan 5 tahun berdirinya RM Padang "Sederhana". <br>', '', '1', '2015-05-29', '14:32', '1432884730');
/*!40000 ALTER TABLE `tb_hlm_berita` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_berita_foto
CREATE TABLE IF NOT EXISTS `tb_hlm_berita_foto` (
  `nomor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `nama_berkas` varchar(256) NOT NULL,
  `nama_berkas_asli` varchar(256) NOT NULL,
  `ekstensi` varchar(8) NOT NULL,
  `sampul` varchar(1) NOT NULL,
  `keterangan` text NOT NULL,
  `kode_hlm_berita` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_berita_foto: ~4 rows (approximately)
DELETE FROM `tb_hlm_berita_foto`;
/*!40000 ALTER TABLE `tb_hlm_berita_foto` DISABLE KEYS */;
INSERT INTO `tb_hlm_berita_foto` (`nomor`, `kode`, `nama`, `nama_berkas`, `nama_berkas_asli`, `ekstensi`, `sampul`, `keterangan`, `kode_hlm_berita`) VALUES
	(64, 'FPEMFPKYZYCWFQK8', 'Test', 'BsEHyyvc5eUFkaxaUhtNBqXfF368gdJfu4sUEp2EY37WKy5rzZBF4VUp', 'Campbell.jpg', '.jpg', '0', '', 'BTVPEENT'),
	(65, 'FPBP7ZAXWUZB608K', 'Test 2', 'MhsERRMxT0Br9vwemqrWxPYpzGkU1srevWWAPWa0mF6jHHXw1QuDqZPR', 'Monkey.jpg', '.jpg', '1', '', 'BTVPEENT'),
	(66, 'FPFNXXWXEWJFFAAA', 'Test 3', 'fjkme2m3NCG9qEMd1kYrbwThwStNeR2JVhTUbJuNn1wZCS1UAfgMJkZw', 'Martin.jpg', '.jpg', '0', '', 'BTVPEENT'),
	(67, 'FPHMKW9JRSKA9QA6', 'Test', 'NTXbMzmWgdgWPq0uYrGNw4Wvj4VcuEYzf8q7vPsRjcDv8dFrzeUv7N7c', 'Universe Expression.jpg', '.jpg', '0', '', 'BTHSV1SU');
/*!40000 ALTER TABLE `tb_hlm_berita_foto` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_kontak
CREATE TABLE IF NOT EXISTS `tb_hlm_kontak` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `teks` text,
  `kode_foto` varchar(8) DEFAULT NULL,
  `publikasi` varchar(1) DEFAULT NULL,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_kontak: ~0 rows (approximately)
DELETE FROM `tb_hlm_kontak`;
/*!40000 ALTER TABLE `tb_hlm_kontak` DISABLE KEYS */;
INSERT INTO `tb_hlm_kontak` (`nomor`, `teks`, `kode_foto`, `publikasi`, `tanggal`, `jam`) VALUES
	(1, 'Silahkan menghubungi kami melalui formulir berikut:<br>', 'Test', '1', '2015-05-27', '10:33');
/*!40000 ALTER TABLE `tb_hlm_kontak` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_profil
CREATE TABLE IF NOT EXISTS `tb_hlm_profil` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `teks` text,
  `kode_foto` varchar(8) DEFAULT NULL,
  `publikasi` varchar(1) DEFAULT NULL,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_profil: ~1 rows (approximately)
DELETE FROM `tb_hlm_profil`;
/*!40000 ALTER TABLE `tb_hlm_profil` DISABLE KEYS */;
INSERT INTO `tb_hlm_profil` (`nomor`, `teks`, `kode_foto`, `publikasi`, `tanggal`, `jam`) VALUES
	(1, 'RM Padang "Sederhana" adalah usaha pribumi yang bergerak dibidang masakan Minang (Padang), bahwa Restoran Simpang Raya yang awalnya dari Bukit Tinggi daerah Sumatra Barat oleh kakak kami Alm. Muhammad Noor Datukmaharajo bersama rekan-rekannya dan setelah itu kami coba untuk mengembangkan usaha ini di Pulau Jawa dan sekitarnya dengan niat yang tulus untuk melakukan suatu hijrah. <br><br> Pertama kami mencoba membuka usaha dengan pola kerjasama di Cipanas kabupaten Cianjur dengan sistim kerjasama oleh H. Noersal Zainnudin dan rekan-rekan bersama dengan H. Safri Awih (Alm) sebagai pemilik lokasi. setelah berjalan dengan baik di Cipanas kami coba mengembangkan usaha ini pada tahun 1981 ke Jakarta dan sekitarnya diantaranya : <br><br>Jl. Kramat Raya Jak-Pus, Ancol, Jl. Margonda Raya Depok, dan setelah berjalan dengan baik di Jakarta dan sekitarnya kami kembali membuka cabang di daerah Bandung dan sekitarnya, pertama Jl. Asia Afrika, Jl. Ir H. Juanda (Dago), Jl. Raya Cipacing (Rancaekek), Jl. Terusan Pasteur, dan setelah itu kami buka di Jl. Raya Gadog Ciawi Bogor, dan masih banyak lagi yang belum disebutkan di halaman ini dan yang paling baru di Jl. M. T. Haryono kota Balikpapan (Kalimantan Timur). <br><br> Alhamdulillah berkat rahmat Allah Subhanahu wa ta\'ala, usaha restoran kami berjalan dengan baik. Pada tahun 1990 banyak berdiri restoran-restoran Padang di areal Jakarta maupun di kota-kota besar lainnya dan berhubung pada tahun tersebut nama RM Padang "Sederhana" cukup dikenal masyarakat banyak diantara restoran tersebut yang meniru baik lambang maupun merek RM Padang "Sederhana", hal ini cukup mengkhawatirkan manajemen restoran RM Padang "Sederhana" karena dapat berdampak pada citra perusahaan itu sendiri.', 'test', '1', '2015-05-24', '23:05');
/*!40000 ALTER TABLE `tb_hlm_profil` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_hlm_syarat
CREATE TABLE IF NOT EXISTS `tb_hlm_syarat` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `teks` text,
  `kode_foto` varchar(8) DEFAULT NULL,
  `publikasi` varchar(1) DEFAULT NULL,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_hlm_syarat: ~0 rows (approximately)
DELETE FROM `tb_hlm_syarat`;
/*!40000 ALTER TABLE `tb_hlm_syarat` DISABLE KEYS */;
INSERT INTO `tb_hlm_syarat` (`nomor`, `teks`, `kode_foto`, `publikasi`, `tanggal`, `jam`) VALUES
	(1, '<span title="RM Padang " sederhana"="" syarat="" layanan="" ("agreement")"="">RM Padang "Sederhana" Syarat LAYANAN ("Perjanjian")<br><br></span><span title="This Agreement was last modified on October 30, 2013. ">Perjanjian ini terakhir diubah pada tanggal 30 Oktober 2013. <br><br></span><span title="Please read these Terms of Service (" agreement", ="" "terms="" of="" service")="" carefully="" before="" using="" http:="" pesanantar. ="" "="">Silakan baca Ketentuan Layanan ini ("Perjanjian", "Ketentuan Layanan") dengan hati-hati sebelum menggunakan http://pesanantar. </span><span title="cloudapp. ">cloudapp. net</span><span title="net (" the="" site")="" operated="" by="" pt. ="" "=""> ("Situs") yang dioperasikan oleh PT. </span><span title="RMP Sederhana (" us", ="" "we", ="" or="" "our"). ="" "="">RMP Sederhana ("kami", "kita", atau "kami"). </span><span title="This Agreement sets forth the legally binding terms and conditions for your use of the Site at http://pesanantar. ">Perjanjian ini menetapkan syarat dan ketentuan yang mengikat secara hukum untuk penggunaan Situs di </span><span title="Please read these Terms of Service (">http://pesanantar. </span><span title="cloudapp. ">cloudapp. net</span><span title="net. ">. <br><br></span><span title="By accessing or using the Site in any manner, including, but not limited to, visiting or browsing the Site or contributing content or other materials to the Site, you agree to be bound by these Terms of Service. ">Dengan mengakses atau menggunakan Situs ini dengan cara apapun, termasuk, namun tidak terbatas pada, mengunjungi atau browsing Situs atau memberikan kontribusi konten atau materi lainnya untuk Situs, Anda setuju untuk terikat oleh Syarat Layanan ini. </span><span title="Capitalized terms are defined in this Agreement. ">Istilah dikapitalisasi didefinisikan dalam Perjanjian ini. <br></span><span title="Intellectual Property"><br>Kekayaan Intelektual<br><br></span><span title="The Site and its original content, features and functionality are owned by PT. ">Situs dan konten asli, fitur dan fungsi yang dimiliki oleh </span><span title="net (">PT. </span><span title="RMP Sederhana (">RMP Sederhana</span><span title="Eka Bogainti and are protected by international copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws. "> dan dilindungi oleh hak cipta internasional, merek dagang, paten, rahasia dagang dan kekayaan intelektual atau hak kepemilikan hukum lainnya. <br></span><span title="Termination"><br>Penghentian<br><br></span><span title="We may terminate your access to the Site, without cause or notice, which may result in the forfeiture and destruction of all information associated with you. ">Kami dapat menghentikan akses Anda ke Situs, tanpa sebab atau pemberitahuan, yang dapat mengakibatkan perampasan dan penghancuran semua informasi yang terkait dengan Anda. </span><span title="All provisions of this Agreement that by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability. ">Semua ketentuan Perjanjian ini yang menurut sifatnya harus bertahan pemutusan akan tetap pemutusan, termasuk, tanpa batasan, ketentuan kepemilikan, penolakan garansi, ganti rugi, dan batasan tanggung jawab. <br></span><span title="Links To Other Sites"><br>Link Untuk Situs Lain<br><br></span><span title="Our Site may contain links to third-party sites that are not owned or controlled by PT. ">Situs kami mungkin berisi link ke situs pihak ketiga yang tidak dimiliki atau dikendalikan oleh PT. </span><span title="RMP Sederhana. ">RMP Sederhana. <br><br></span><span title="PT. ">PT. </span><span title="RMP Sederhana has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party sites or services. ">RMP Sederhana tidak memiliki kontrol atas, dan tidak bertanggung jawab, isi, kebijakan privasi, atau praktik dari situs-situs pihak ketiga atau layanan. </span><span title="We strongly advise you to read the terms and conditions and privacy policy of any third-party site that you visit. ">Kami sangat menyarankan Anda untuk membaca syarat dan ketentuan serta kebijakan privasi dari situs pihak ketiga yang Anda kunjungi. <br></span><span title="Governing Law"><br>Hukum yang mengatur<br><br></span><span title="This Agreement (and any further rules, polices, or guidelines incorporated by reference) shall be governed and construed in accordance with the laws of Republic of Indonesia, without giving effect to any principles of conflicts of law. ">Perjanjian ini (dan lebih jauh aturan, kebijakan, atau pedoman dimasukkan oleh referensi) akan diatur dan ditafsirkan sesuai dengan hukum Republik Indonesia, tanpa mempengaruhi prinsip-prinsip konflik hukum. <br></span><span title="Changes To This Agreement"><br>Perubahan Untuk Perjanjian ini<br><br></span><span title="We reserve the right, at our sole discretion, to modify or replace these Terms of Service by posting the updated terms on the Site. ">Kami berhak, atas kebijakan kami, untuk memodifikasi atau mengganti Ketentuan Layanan ini dengan posting yang diperbarui Istilah di Situs. </span><span title="Your continued use of the Site after any such changes constitutes your acceptance of the new Terms of Service. ">Dengan terus menggunakan Situs setelah perubahan tersebut merupakan penerimaan Anda dari Syarat baru Layanan. <br><br></span><span title="Please review this Agreement periodically for changes. ">Harap tinjau Perjanjian ini secara berkala untuk perubahan. </span><span title="If you do not agree to any of this Agreement or any changes to this Agreement, do not use, access or continue to access the Site or discontinue any use of the Site immediately. ">Jika Anda tidak setuju dengan salah Perjanjian ini atau perubahan Perjanjian ini, jangan gunakan, akses atau terus mengakses Situs atau menghentikan setiap penggunaan Situs segera. <br></span><span title="Contact Us"><br>Hubungi Kami<br><br></span><span title="If you have any questions about this Agreement, please contact us. ">Jika Anda memiliki pertanyaan tentang Perjanjian ini, silahkan hubungi kami. </span>', 'test', '1', '2015-05-24', '10:09');
/*!40000 ALTER TABLE `tb_hlm_syarat` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_karyawan
CREATE TABLE IF NOT EXISTS `tb_karyawan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `kode_orang` varchar(16) NOT NULL,
  `sandi` varchar(128) NOT NULL,
  `aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_orang_UNIQUE` (`kode_orang`),
  KEY `karyawan_kode_orang` (`kode_orang`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_karyawan: ~0 rows (approximately)
DELETE FROM `tb_karyawan`;
/*!40000 ALTER TABLE `tb_karyawan` DISABLE KEYS */;
INSERT INTO `tb_karyawan` (`nomor`, `kode`, `kode_orang`, `sandi`, `aktif`) VALUES
	(1, 'KRY0000000000001', 'ORG0000000000001', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', '1');
/*!40000 ALTER TABLE `tb_karyawan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_kategori_menu
CREATE TABLE IF NOT EXISTS `tb_kategori_menu` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_kategori_menu: ~0 rows (approximately)
DELETE FROM `tb_kategori_menu`;
/*!40000 ALTER TABLE `tb_kategori_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_kategori_menu` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_kategori_operator
CREATE TABLE IF NOT EXISTS `tb_kategori_operator` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(45) DEFAULT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_kategori_operator: ~0 rows (approximately)
DELETE FROM `tb_kategori_operator`;
/*!40000 ALTER TABLE `tb_kategori_operator` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_kategori_operator` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_kontak_alamat
CREATE TABLE IF NOT EXISTS `tb_kontak_alamat` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) DEFAULT NULL,
  `kode_geo_jalan` varchar(8) DEFAULT NULL,
  `kode_geo_kecamatan` varchar(8) DEFAULT NULL,
  `kode_geo_kabupaten` varchar(8) DEFAULT NULL,
  `kode_geo_provinsi` varchar(8) DEFAULT NULL,
  `kode_geo_negara` varchar(8) DEFAULT NULL,
  `kode_geo_kode pos` varchar(8) DEFAULT NULL,
  `lintang` varchar(16) DEFAULT NULL,
  `bujur` varchar(16) DEFAULT NULL,
  `catatan` text,
  `status_aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`),
  KEY `kontak_alamat_kode_negara` (`kode_geo_negara`),
  KEY `kontak_alamat_kode_provinsi` (`kode_geo_provinsi`),
  KEY `kontak_alamat_kode_kabupaten` (`kode_geo_kabupaten`),
  KEY `kontak_alamat_kode_kecamatan` (`kode_geo_kecamatan`),
  KEY `kontak_alamat_kode_jalan` (`kode_geo_jalan`),
  KEY `kontak_alamat_kode_orang` (`kode_orang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_kontak_alamat: ~0 rows (approximately)
DELETE FROM `tb_kontak_alamat`;
/*!40000 ALTER TABLE `tb_kontak_alamat` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_kontak_alamat` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_kontak_email
CREATE TABLE IF NOT EXISTS `tb_kontak_email` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) NOT NULL,
  `email` varchar(64) NOT NULL,
  `status_aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `kontak_email_kode_orang` (`kode_orang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_kontak_email: ~0 rows (approximately)
DELETE FROM `tb_kontak_email`;
/*!40000 ALTER TABLE `tb_kontak_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_kontak_email` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_kontak_telepon
CREATE TABLE IF NOT EXISTS `tb_kontak_telepon` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) NOT NULL,
  `nomor_telepon` varchar(32) DEFAULT NULL,
  `kode_telp_negara` varchar(8) NOT NULL,
  `status_aktif` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `kontak_telepon_kode_orang` (`kode_orang`),
  KEY `kontak_telepon_kode_telkom_telp_negara` (`kode_telp_negara`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_kontak_telepon: ~0 rows (approximately)
DELETE FROM `tb_kontak_telepon`;
/*!40000 ALTER TABLE `tb_kontak_telepon` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_kontak_telepon` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_lokasi_pelanggan
CREATE TABLE IF NOT EXISTS `tb_lokasi_pelanggan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) DEFAULT NULL,
  `lintang` varchar(64) DEFAULT NULL,
  `bujur` varchar(64) DEFAULT NULL,
  `alamat` text,
  `catatan` text,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_lokasi_pelanggan: ~2 rows (approximately)
DELETE FROM `tb_lokasi_pelanggan`;
/*!40000 ALTER TABLE `tb_lokasi_pelanggan` DISABLE KEYS */;
INSERT INTO `tb_lokasi_pelanggan` (`nomor`, `kode_orang`, `lintang`, `bujur`, `alamat`, `catatan`) VALUES
	(1, 'ORYZUMUUMQKM4M56', '-6.367805209052893', '106.81674021653293', 'Jalan KH Ahmad Dahlan, Beji, Kota Depok, Jawa Barat 16425, Republic of Indonesia', ''),
	(2, 'ORP5G8T5KBUEQ5EU', '-6.377571238563825', '106.81383810937041', 'Jalan Haji Asmawi No. 72-75, Beji, Kota Depok, Jawa Barat 16421, Indonesia', 'Lantai 1, kamar no. 12');
/*!40000 ALTER TABLE `tb_lokasi_pelanggan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_metode_bayar
CREATE TABLE IF NOT EXISTS `tb_metode_bayar` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_metode_bayar: ~0 rows (approximately)
DELETE FROM `tb_metode_bayar`;
/*!40000 ALTER TABLE `tb_metode_bayar` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_metode_bayar` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_metode_pesan
CREATE TABLE IF NOT EXISTS `tb_metode_pesan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_metode_pesan: ~0 rows (approximately)
DELETE FROM `tb_metode_pesan`;
/*!40000 ALTER TABLE `tb_metode_pesan` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_metode_pesan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_operator
CREATE TABLE IF NOT EXISTS `tb_operator` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(16) NOT NULL,
  `sandi` varchar(16) DEFAULT NULL,
  `kategori_operator` varchar(8) DEFAULT NULL,
  `kode_karyawan` varchar(16) DEFAULT NULL,
  `catatan` varchar(45) DEFAULT NULL,
  `aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`,`nama`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  KEY `operator_kode_kategori_operator` (`kategori_operator`),
  KEY `operator_kode_karyawan` (`kode_karyawan`),
  CONSTRAINT `operator_kode_karyawan` FOREIGN KEY (`kode_karyawan`) REFERENCES `tb_karyawan` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `operator_kode_kategori_operator` FOREIGN KEY (`kategori_operator`) REFERENCES `tb_kategori_operator` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_operator: ~0 rows (approximately)
DELETE FROM `tb_operator`;
/*!40000 ALTER TABLE `tb_operator` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_operator` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_operator_dapur
CREATE TABLE IF NOT EXISTS `tb_operator_dapur` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_faktur` varchar(16) NOT NULL,
  `kode_operator` varchar(16) NOT NULL,
  `kode_orang_pelanggan` varchar(16) NOT NULL,
  `status_proses` varchar(1) NOT NULL,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  `timestamp` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `kode_faktur` (`kode_faktur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_operator_dapur: ~2 rows (approximately)
DELETE FROM `tb_operator_dapur`;
/*!40000 ALTER TABLE `tb_operator_dapur` DISABLE KEYS */;
INSERT INTO `tb_operator_dapur` (`nomor`, `kode_faktur`, `kode_operator`, `kode_orang_pelanggan`, `status_proses`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'FKYFSGFGYPH4K414', 'OPSXER58', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '12:48', ''),
	(2, 'FKWSSNU8XBZH9CSR', 'OPSXER58', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '12:58', ''),
	(3, 'FKXVH4AUTQU3BFAC', 'OPSXER58', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '14:34', '');
/*!40000 ALTER TABLE `tb_operator_dapur` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_operator_kurir
CREATE TABLE IF NOT EXISTS `tb_operator_kurir` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_faktur` varchar(16) NOT NULL,
  `kode_operator` varchar(16) NOT NULL,
  `kode_orang_pelanggan` varchar(16) NOT NULL,
  `status_proses` varchar(1) NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) NOT NULL,
  `timestamp` varchar(128) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `kode_faktur` (`kode_faktur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_operator_kurir: ~2 rows (approximately)
DELETE FROM `tb_operator_kurir`;
/*!40000 ALTER TABLE `tb_operator_kurir` DISABLE KEYS */;
INSERT INTO `tb_operator_kurir` (`nomor`, `kode_faktur`, `kode_operator`, `kode_orang_pelanggan`, `status_proses`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'FKYFSGFGYPH4K414', 'OPEXMTFG', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '12:51', ''),
	(2, 'FKWSSNU8XBZH9CSR', 'OPEXMTFG', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '14:38', ''),
	(3, 'FKXVH4AUTQU3BFAC', 'OPEXMTFG', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '14:37', '');
/*!40000 ALTER TABLE `tb_operator_kurir` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_operator_pemesanan
CREATE TABLE IF NOT EXISTS `tb_operator_pemesanan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_faktur` varchar(16) NOT NULL,
  `kode_operator` varchar(16) NOT NULL,
  `kode_orang_pelanggan` varchar(16) NOT NULL,
  `status_proses` varchar(1) NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) DEFAULT NULL,
  `timestamp` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `kode_faktur` (`kode_faktur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_operator_pemesanan: ~2 rows (approximately)
DELETE FROM `tb_operator_pemesanan`;
/*!40000 ALTER TABLE `tb_operator_pemesanan` DISABLE KEYS */;
INSERT INTO `tb_operator_pemesanan` (`nomor`, `kode_faktur`, `kode_operator`, `kode_orang_pelanggan`, `status_proses`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'FKYFSGFGYPH4K414', 'OPMX7DY6', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '12:14', ''),
	(2, 'FKWSSNU8XBZH9CSR', 'OPMX7DY6', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '12:57', ''),
	(3, 'FKXVH4AUTQU3BFAC', 'OPMX7DY6', 'ORP5G8T5KBUEQ5EU', '1', '2015-06-12', '14:22', '');
/*!40000 ALTER TABLE `tb_operator_pemesanan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_orang_finansial
CREATE TABLE IF NOT EXISTS `tb_orang_finansial` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) DEFAULT NULL,
  `kode_perusahaan_finansial` varchar(16) DEFAULT NULL,
  `nomor_rekening` varchar(32) DEFAULT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `orang_finansial_kode_orang` (`kode_orang`),
  KEY `orang_finansial_kode_perusahaan_finansial` (`kode_perusahaan_finansial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_orang_finansial: ~0 rows (approximately)
DELETE FROM `tb_orang_finansial`;
/*!40000 ALTER TABLE `tb_orang_finansial` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_orang_finansial` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_orang_identitas
CREATE TABLE IF NOT EXISTS `tb_orang_identitas` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orang` varchar(16) NOT NULL,
  `kode_jenis_identitas` varchar(8) NOT NULL,
  `nomor_id` varchar(24) NOT NULL,
  `foto` varchar(64) DEFAULT NULL,
  `tanggal_dibuat` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_id_UNIQUE` (`nomor_id`),
  KEY `orang_identitas_kode_orang` (`kode_orang`),
  KEY `orang_identitas_kode_jenis_identitas` (`kode_jenis_identitas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_orang_identitas: ~0 rows (approximately)
DELETE FROM `tb_orang_identitas`;
/*!40000 ALTER TABLE `tb_orang_identitas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_orang_identitas` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_pelanggan
CREATE TABLE IF NOT EXISTS `tb_pelanggan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `email` varchar(64) NOT NULL,
  `sandi` varchar(255) NOT NULL,
  `kode_orang` varchar(16) NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `kode_orang_UNIQUE` (`kode_orang`),
  KEY `kode_orang` (`kode_orang`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_pelanggan: ~6 rows (approximately)
DELETE FROM `tb_pelanggan`;
/*!40000 ALTER TABLE `tb_pelanggan` DISABLE KEYS */;
INSERT INTO `tb_pelanggan` (`nomor`, `kode`, `email`, `sandi`, `kode_orang`, `tanggal`) VALUES
	(1, 'PGVMCWFPA2ZGU51Y', 'ridwan@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORMMWB1NCCW0SDSH', '2015-5-6'),
	(2, 'PG50RDNFPZPCYMJD', 'joko@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORP5G8T5KBUEQ5EU', '2015-6-12'),
	(3, 'PGJ5BDZQQHJDZHKF', 'susilo@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORRZZGFNGDTNTNVW', '2015-5-6'),
	(4, 'PG3E8QCF3V3WVAGT', 'yusuf@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORYTV0MCWEC6D0W8', '2015-5-6'),
	(5, 'PGZ8KDDTPG9DKUUT', 'lulung@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORJTUFUWTVR66NRR', '2015-5-6'),
	(6, 'PGTUTMNNP4WM4DCB', 'mitra@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORCWFD3S2PAH6XZC', '2015-5-6'),
	(7, 'PGCT38Z94KZHRFWJ', 'surya@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORSABG80K7CRXFUN', '2015-5-6'),
	(8, 'PGPGUUCJ7SSVMUHC', 'made@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORYZUMUUMQKM4M56', '2015-5-14'),
	(9, 'PGT3JVVTYP1AFC9F', 'rudi@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORYNWMYK2VVRDHQ4', '2015-5-19'),
	(10, 'PGNXBXJQHSTDXB8W', 'surya@yahoo.com', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', 'ORSMQSNB2GRPJ00X', '2015-5-22');
/*!40000 ALTER TABLE `tb_pelanggan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_pengantaran
CREATE TABLE IF NOT EXISTS `tb_pengantaran` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `kode_faktur_jual` varchar(16) NOT NULL,
  `nama_operator_kurir` varchar(16) NOT NULL,
  `tanggal_berangkat` date NOT NULL,
  `jam_berangkat` time NOT NULL,
  `tanggal_tiba` date NOT NULL,
  `jam_tiba` time NOT NULL,
  `status_tiba` varchar(1) NOT NULL,
  `catatan` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `pengantaran_kode_faktur_jual` (`kode_faktur_jual`),
  KEY `pengantaran_nama_operator` (`nama_operator_kurir`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_pengantaran: ~0 rows (approximately)
DELETE FROM `tb_pengantaran`;
/*!40000 ALTER TABLE `tb_pengantaran` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_pengantaran` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_pengaturan_lokasi
CREATE TABLE IF NOT EXISTS `tb_pengaturan_lokasi` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `lintang` varchar(64) DEFAULT NULL,
  `bujur` varchar(64) DEFAULT NULL,
  `kode_geo_negara` varchar(8) DEFAULT NULL,
  `kode_geo_provinsi` varchar(8) DEFAULT NULL,
  `kode_geo_kabupaten` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_pengaturan_lokasi: ~1 rows (approximately)
DELETE FROM `tb_pengaturan_lokasi`;
/*!40000 ALTER TABLE `tb_pengaturan_lokasi` DISABLE KEYS */;
INSERT INTO `tb_pengaturan_lokasi` (`nomor`, `lintang`, `bujur`, `kode_geo_negara`, `kode_geo_provinsi`, `kode_geo_kabupaten`) VALUES
	(1, '-6.36627768466378', '106.8341075198822', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2');
/*!40000 ALTER TABLE `tb_pengaturan_lokasi` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_perusahaan_finansial
CREATE TABLE IF NOT EXISTS `tb_perusahaan_finansial` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `nomor_rekening` varchar(32) NOT NULL,
  `sandi_api` varchar(128) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_perusahaan_finansial: ~0 rows (approximately)
DELETE FROM `tb_perusahaan_finansial`;
/*!40000 ALTER TABLE `tb_perusahaan_finansial` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_perusahaan_finansial` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_produk_satuan
CREATE TABLE IF NOT EXISTS `tb_produk_satuan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(128) NOT NULL,
  `singkatan` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  UNIQUE KEY `singkatan_UNIQUE` (`singkatan`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_produk_satuan: ~7 rows (approximately)
DELETE FROM `tb_produk_satuan`;
/*!40000 ALTER TABLE `tb_produk_satuan` DISABLE KEYS */;
INSERT INTO `tb_produk_satuan` (`nomor`, `kode`, `nama`, `singkatan`, `catatan`) VALUES
	(3, 'STZWK5EC', 'Piring', 'pir', ''),
	(4, 'STWQXNFQ', 'Gelas', 'gls', ''),
	(5, 'STCX6GD6', 'Mangkok', 'mko', ''),
	(6, 'STXC8PNT', 'Bungkus', 'bks', ''),
	(7, 'STKHB6VJ', 'Porsi', 'por', ''),
	(8, 'STHK1ZZX', 'Cangkir', 'ckr', ''),
	(9, 'ST8J6P9W', 'Botol', 'btl', '');
/*!40000 ALTER TABLE `tb_produk_satuan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_publik_kontak
CREATE TABLE IF NOT EXISTS `tb_publik_kontak` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(32) NOT NULL,
  `email` varchar(32) NOT NULL,
  `perihal` varchar(64) NOT NULL,
  `komentar` text NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) NOT NULL,
  `timestamp` varchar(128) NOT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_publik_kontak: ~0 rows (approximately)
DELETE FROM `tb_publik_kontak`;
/*!40000 ALTER TABLE `tb_publik_kontak` DISABLE KEYS */;
INSERT INTO `tb_publik_kontak` (`nomor`, `nama`, `email`, `perihal`, `komentar`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'I Made Ariana', 'fluoresen@yahoo.com', 'Terima kasih', 'Terima kasih atas pelayanan yang diberikan.', '2015-05-27', '10:50', '1432698630');
/*!40000 ALTER TABLE `tb_publik_kontak` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_biaya_kurir
CREATE TABLE IF NOT EXISTS `tb_resto_biaya_kurir` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `biaya` text,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  `timestamp` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_biaya_kurir: ~0 rows (approximately)
DELETE FROM `tb_resto_biaya_kurir`;
/*!40000 ALTER TABLE `tb_resto_biaya_kurir` DISABLE KEYS */;
INSERT INTO `tb_resto_biaya_kurir` (`nomor`, `biaya`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, '13000', '2015-06-01', '10:54', '1433130878');
/*!40000 ALTER TABLE `tb_resto_biaya_kurir` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_departemen
CREATE TABLE IF NOT EXISTS `tb_resto_departemen` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_departemen: ~4 rows (approximately)
DELETE FROM `tb_resto_departemen`;
/*!40000 ALTER TABLE `tb_resto_departemen` DISABLE KEYS */;
INSERT INTO `tb_resto_departemen` (`nomor`, `kode`, `nama`, `catatan`) VALUES
	(15, 'DPSPY1RW', 'Penjualan dan Pemasaran', ''),
	(16, 'DPCUQFXR', 'Makanan dan Minuman', ''),
	(17, 'DP1GPA34', 'Pengantaran', ''),
	(18, 'DPV3RHFB', 'Keamanan', ''),
	(19, 'DPKKJTYG', 'Teknologi Informasi', '');
/*!40000 ALTER TABLE `tb_resto_departemen` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_jenis_operator
CREATE TABLE IF NOT EXISTS `tb_resto_jenis_operator` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_jenis_operator: ~4 rows (approximately)
DELETE FROM `tb_resto_jenis_operator`;
/*!40000 ALTER TABLE `tb_resto_jenis_operator` DISABLE KEYS */;
INSERT INTO `tb_resto_jenis_operator` (`nomor`, `kode`, `nama`, `catatan`) VALUES
	(15, 'JOFK7ABU', 'Pelayanan Konsumen', ''),
	(16, 'JOEF4WJE', 'Juru Masak', ''),
	(17, 'JORYQRVH', 'Pengantar', ''),
	(18, 'JOGPYZNM', 'Kasir', '');
/*!40000 ALTER TABLE `tb_resto_jenis_operator` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_jenis_produk
CREATE TABLE IF NOT EXISTS `tb_resto_jenis_produk` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `catatan` text,
  `kode_resto_kategori_produk` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_jenis_produk: ~4 rows (approximately)
DELETE FROM `tb_resto_jenis_produk`;
/*!40000 ALTER TABLE `tb_resto_jenis_produk` DISABLE KEYS */;
INSERT INTO `tb_resto_jenis_produk` (`nomor`, `kode`, `nama`, `catatan`, `kode_resto_kategori_produk`) VALUES
	(3, 'JP4KGXTU', 'Nasi Lengkap', '', 'KPJYA6QN'),
	(4, 'JPFSBCFD', 'Berkuah', '', 'KPJYA6QN'),
	(5, 'JPG4VS2G', 'Dingin', '', 'KPUCBGBW'),
	(6, 'JPNFJJUA', 'Hangat', '', 'KPUCBGBW'),
	(7, 'JPBYHDCF', 'Jus', '', 'KPUCBGBW');
/*!40000 ALTER TABLE `tb_resto_jenis_produk` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_karyawan
CREATE TABLE IF NOT EXISTS `tb_resto_karyawan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(45) NOT NULL,
  `catatan` text,
  `kode_resto_departemen` varchar(8) NOT NULL,
  `kode_resto_pekerjaan` varchar(8) NOT NULL,
  `kode_sipil_orang` varchar(16) NOT NULL,
  `tanggal_masuk` varchar(10) NOT NULL,
  `tanggal_berhenti` varchar(10) NOT NULL,
  `aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_karyawan: ~2 rows (approximately)
DELETE FROM `tb_resto_karyawan`;
/*!40000 ALTER TABLE `tb_resto_karyawan` DISABLE KEYS */;
INSERT INTO `tb_resto_karyawan` (`nomor`, `kode`, `nama`, `catatan`, `kode_resto_departemen`, `kode_resto_pekerjaan`, `kode_sipil_orang`, `tanggal_masuk`, `tanggal_berhenti`, `aktif`) VALUES
	(141, 'KRBR1UDA', 'Eka Qadri Nuranti B', '', 'DPSPY1RW', 'PKU353J7', 'OR0FTCHEGAAZSJNF', '2015-05-05', '2016-05-05', '1'),
	(142, 'KRSRP8GX', 'Adrian Setyadi', '', 'DPCUQFXR', 'PKQTXD1M', 'ORBSXHXRB1T7KUFV', '2015-05-05', '2016-05-05', '1'),
	(143, 'KRSASYFF', 'I Made Ariana', '', 'DP1GPA34', 'PK539VAM', 'ORBPPXJM170MEQ5K', '2015-05-05', '2016-05-05', '1'),
	(144, 'KR3GKFDK', 'Abd Cde', '', 'DPSPY1RW', 'PKU353J7', 'ORXNKRBCWVJUR1VG', '2015-06-11', '2015-06-18', '1');
/*!40000 ALTER TABLE `tb_resto_karyawan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_kategori_produk
CREATE TABLE IF NOT EXISTS `tb_resto_kategori_produk` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_resto_kategori_produk: ~2 rows (approximately)
DELETE FROM `tb_resto_kategori_produk`;
/*!40000 ALTER TABLE `tb_resto_kategori_produk` DISABLE KEYS */;
INSERT INTO `tb_resto_kategori_produk` (`nomor`, `kode`, `nama`, `catatan`) VALUES
	(5, 'KPJYA6QN', 'Makanan', ''),
	(6, 'KPUCBGBW', 'Minuman', ''),
	(7, 'KPT2DXN2', 'Mainan', '');
/*!40000 ALTER TABLE `tb_resto_kategori_produk` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_operator
CREATE TABLE IF NOT EXISTS `tb_resto_operator` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(45) NOT NULL,
  `sandi` varchar(255) NOT NULL,
  `catatan` text,
  `kode_resto_karyawan` varchar(16) NOT NULL,
  `kode_resto_jenis_operator` varchar(8) NOT NULL,
  `aktif` varchar(1) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_operator: ~2 rows (approximately)
DELETE FROM `tb_resto_operator`;
/*!40000 ALTER TABLE `tb_resto_operator` DISABLE KEYS */;
INSERT INTO `tb_resto_operator` (`nomor`, `kode`, `nama`, `sandi`, `catatan`, `kode_resto_karyawan`, `kode_resto_jenis_operator`, `aktif`) VALUES
	(1, 'OPMX7DY6', 'Eka Qadri Nuranti B', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', '', 'KRBR1UDA', 'JOFK7ABU', '1'),
	(2, 'OPSXER58', 'Adrian Setyadi', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', '', 'KRSRP8GX', 'JOEF4WJE', '1'),
	(3, 'OPEXMTFG', 'I Made Ariana', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', '', 'KRSASYFF', 'JORYQRVH', '1'),
	(4, 'OPUGBERR', 'Abd Cde', 'c741a75319e5724ca59a9fa2f69ae714cf13d39f6d7f6aaeba839bb599b4cf4d', '', 'KR3GKFDK', 'JOFK7ABU', '1');
/*!40000 ALTER TABLE `tb_resto_operator` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_pajak
CREATE TABLE IF NOT EXISTS `tb_resto_pajak` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `pajak` text,
  `tanggal` varchar(10) DEFAULT NULL,
  `jam` varchar(5) DEFAULT NULL,
  `timestamp` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`nomor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_pajak: ~0 rows (approximately)
DELETE FROM `tb_resto_pajak`;
/*!40000 ALTER TABLE `tb_resto_pajak` DISABLE KEYS */;
INSERT INTO `tb_resto_pajak` (`nomor`, `pajak`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, '10', '2015-06-01', '12:05', '1433135118');
/*!40000 ALTER TABLE `tb_resto_pajak` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_pekerjaan
CREATE TABLE IF NOT EXISTS `tb_resto_pekerjaan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `catatan` text,
  `kode_resto_departemen` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_pekerjaan: ~4 rows (approximately)
DELETE FROM `tb_resto_pekerjaan`;
/*!40000 ALTER TABLE `tb_resto_pekerjaan` DISABLE KEYS */;
INSERT INTO `tb_resto_pekerjaan` (`nomor`, `kode`, `nama`, `catatan`, `kode_resto_departemen`) VALUES
	(10, 'PK539VAM', 'Pengantar', 'Bertugas mengantar makanan dan minuman.', 'DP1GPA34'),
	(11, 'PKU353J7', 'Pelayanan Konsumen', 'Bertugas melayani konsumen.', 'DPSPY1RW'),
	(12, 'PKQTXD1M', 'Juru Masak', 'Bertugas memasak makanan.', 'DPCUQFXR'),
	(13, 'PK20WQGS', 'Pemasukan Data', '', 'DPKKJTYG');
/*!40000 ALTER TABLE `tb_resto_pekerjaan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_produk
CREATE TABLE IF NOT EXISTS `tb_resto_produk` (
  `nomor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(64) DEFAULT NULL,
  `catatan` text,
  `kode_resto_kategori_produk` varchar(8) NOT NULL,
  `kode_resto_jenis_produk` varchar(8) NOT NULL,
  `kode_produk_satuan` varchar(8) NOT NULL,
  `harga` varchar(10) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  KEY `produk_kode_kategori_produk` (`kode_resto_kategori_produk`),
  KEY `produk_kode_kategori_menu` (`kode_resto_jenis_produk`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_resto_produk: ~6 rows (approximately)
DELETE FROM `tb_resto_produk`;
/*!40000 ALTER TABLE `tb_resto_produk` DISABLE KEYS */;
INSERT INTO `tb_resto_produk` (`nomor`, `kode`, `nama`, `catatan`, `kode_resto_kategori_produk`, `kode_resto_jenis_produk`, `kode_produk_satuan`, `harga`) VALUES
	(1, 'PDFAGG7H', 'Cumi Saus Pedas', '', 'KPJYA6QN', 'JP4KGXTU', 'STKHB6VJ', '20000'),
	(2, 'PDMGXNPZ', 'Jus Alpukat', '', 'KPUCBGBW', 'JPBYHDCF', 'STWQXNFQ', '10000'),
	(3, 'PDWZPMCF', 'Nasi Rames Spesial', '', 'KPJYA6QN', 'JP4KGXTU', 'STZWK5EC', '18000'),
	(4, 'PD261M4T', 'Kepiting Saus Padang', '', 'KPJYA6QN', 'JPFSBCFD', 'STKHB6VJ', '18000'),
	(5, 'PDMMKXW2', 'Ikan Nila Bakar Spesial', '', 'KPJYA6QN', 'JP4KGXTU', 'STKHB6VJ', '32000'),
	(6, 'PDCDK03F', 'Gulai Ikan Tongkol', '', 'KPJYA6QN', 'JP4KGXTU', 'STKHB6VJ', '25000'),
	(7, 'PDJRGRKK', 'Test', '', 'KPJYA6QN', 'JP4KGXTU', 'STZWK5EC', '12000');
/*!40000 ALTER TABLE `tb_resto_produk` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_resto_produk_foto
CREATE TABLE IF NOT EXISTS `tb_resto_produk_foto` (
  `nomor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `nama_berkas` varchar(256) NOT NULL,
  `nama_berkas_asli` varchar(256) NOT NULL,
  `ekstensi` varchar(8) NOT NULL,
  `sampul` varchar(1) NOT NULL,
  `keterangan` text NOT NULL,
  `kode_resto_produk` varchar(8) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_resto_produk_foto: ~11 rows (approximately)
DELETE FROM `tb_resto_produk_foto`;
/*!40000 ALTER TABLE `tb_resto_produk_foto` DISABLE KEYS */;
INSERT INTO `tb_resto_produk_foto` (`nomor`, `kode`, `nama`, `nama_berkas`, `nama_berkas_asli`, `ekstensi`, `sampul`, `keterangan`, `kode_resto_produk`) VALUES
	(1, 'FPQTAY8WXR0UWKHE', 'Apl Cokelat', 'FEZWwdbQBbbWU9ASpH6bCvdSQACWm5WEBkrCQErtXWWvrC1dz9fKkxmA', 'avocado-juice.jpg', '.jpg', '1', '', 'PDMGXNPZ'),
	(2, 'FPF3H0TMQGZBXA0M', 'Apl 23', '81bKBY6xVRSJx1JQS0hEx2tZuR8F8fPUPGSCg1w0w7NgFrrunvUBHzYZ', 'avocado-juice2.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(3, 'FPBHECM4DPJBPWEX', 'Alp Strawberry', 'dvdZcNfPZkYshgyNtvCESM5Uh4Wwm1aCNUuF6K1W6gpYVsWDFt4tNnvy', 'Avocado juice strawberry.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(7, 'FPWGD66GZFHFKCYC', 'Jus Alpukat Susu Cokelat', 'JqATU3cPnUATgtmWqn0e5Jkgzm8emvuz16pwaR5esEZmMM8PYWapdUJB', 'alpukatedit.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(8, 'FPH1KAT3UEM7WT31', 'Jus Alpukat Seledri', 'ukgnMvR2BcYJdUrcFMZX8TZNz33kT2A2Xm7sJBnQVs9BWCJpBvjbGasQ', 'Khasiat-Jus-Alpukat.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(9, 'FPQYZVY8HDYJH5AT', 'Jus Alpukat', 'Ahsnh3r8sVeQN4xjD6Zys3rYz9duDbbbbN6zaUZ9bMmjFfrnwaR04E45', 'jus-alpukat.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(10, 'FPF3PEVX1QTYE3HZ', 'Gulai Cumi', 'K5fWb0VTCJGntS2d6nuSau43eefV1xnwfVkv7jXgddGh3gmKkDZPC2gM', 'Gulai-Cumi3.jpg', '.jpg', '1', '', 'PDFAGG7H'),
	(63, 'FPUBR7NERTMXA3GU', 'Test', 'FETY7cpz1C7v6qHzdZ31Q4wk3wbdAhF82n9gRjsHG23GPKzY8EMSPVyH', '270711_1311770559_68_zumodeberrospepinoyaguacate.jpg', '.jpg', '0', '', 'PDMGXNPZ'),
	(64, 'FP0B4YKWJPBWYE7Z', 'Nasi Rames Spesial', 'RByphMgEsHKKJx277e16BsQrjWxczfqtrVJAPYh6HzcPX79Xc1jgW8JQ', 'GL-Travel-WM.M.L-09.jpg', '.jpg', '1', '', 'PDWZPMCF'),
	(65, 'FPXF0VATX5JQC1AH', 'Kepiting Saus Padang', 'trJxFXK0r9urDu7Tbnuh3muGTvQhhx3NWT5JszPWSVzC74SJSkuK09Dk', '147_1_4-Photo.jpg', '.jpg', '1', '', 'PD261M4T'),
	(66, 'FP1S8RVZ9YRXRFTJ', 'Ikan Nila Bakar Spesial', 'kSC4p5x8Pb1nR0aQEDh4nNeqM6qZqpu06vqBNkx8UaYQqCsd9BdWg5tj', 'ikan-nila-bakar-bumbu-padang.jpg', '.jpg', '1', '', 'PDMMKXW2'),
	(67, 'FPPYQSV2RWY2UZRZ', 'Gulai Ikan Tongkol Pedas', '93ZX8DKaHHTS8N25rw1UhaPFU85a4ckhrM2PaxyZU93fE7aG04RGuqpF', 'Resep Gulai Ikan Tongkol Asam Padeh Khas Padang yang Lezat.jpg', '.jpg', '1', '', 'PDCDK03F'),
	(68, 'FPWTSBMZCSXYMWZA', 'Soto Ayam', 'RgxB8ctC520xBvxmctBWURJZQ2XCgwpYPf94qssvEb8x7EKbjcwHNwx1', 'Soto_ayam.JPG', '.jpg', '1', '', 'PDJRGRKK');
/*!40000 ALTER TABLE `tb_resto_produk_foto` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_satuan_produk
CREATE TABLE IF NOT EXISTS `tb_satuan_produk` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(16) NOT NULL,
  `singkatan` varchar(8) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  UNIQUE KEY `singkatan_UNIQUE` (`singkatan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_satuan_produk: ~0 rows (approximately)
DELETE FROM `tb_satuan_produk`;
/*!40000 ALTER TABLE `tb_satuan_produk` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_satuan_produk` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sipil_gelar
CREATE TABLE IF NOT EXISTS `tb_sipil_gelar` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `singkatan` varchar(16) NOT NULL,
  `letak` varchar(1) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_sipil_gelar: ~8 rows (approximately)
DELETE FROM `tb_sipil_gelar`;
/*!40000 ALTER TABLE `tb_sipil_gelar` DISABLE KEYS */;
INSERT INTO `tb_sipil_gelar` (`nomor`, `kode`, `nama`, `singkatan`, `letak`, `catatan`) VALUES
	(5, 'GLFXHGYS', 'Insinyur', 'Ir', '1', ''),
	(6, 'GLAWBQCU', 'Doktor', 'Dr', '1', ''),
	(7, 'GLX1JRVC', 'Sarjana Teknik', 'S. T.', '0', ''),
	(8, 'GLYJJDSU', 'Sarjana Sains', 'S. Si.', '0', ''),
	(9, 'GLVUYCVE', 'Sarjana Komputer', 'S. Kom.', '0', ''),
	(10, 'GLM3PTXF', 'Philosophy Doctor', 'Ph. D.', '0', ''),
	(11, 'GLSJYUF6', 'Master of Science', 'M. Sc.', '0', ''),
	(12, 'GLGPXEAA', 'Dokter', 'dr', '1', '');
/*!40000 ALTER TABLE `tb_sipil_gelar` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sipil_jenis_id
CREATE TABLE IF NOT EXISTS `tb_sipil_jenis_id` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(128) NOT NULL,
  `singkatan` varchar(16) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `nama_UNIQUE` (`nama`),
  UNIQUE KEY `singkatan_UNIQUE` (`singkatan`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_sipil_jenis_id: ~2 rows (approximately)
DELETE FROM `tb_sipil_jenis_id`;
/*!40000 ALTER TABLE `tb_sipil_jenis_id` DISABLE KEYS */;
INSERT INTO `tb_sipil_jenis_id` (`nomor`, `kode`, `nama`, `singkatan`, `catatan`) VALUES
	(1, 'JDG54W6H', 'Kartu Tanda Penduduk', 'KTP', ''),
	(2, 'JDP2YBJE', 'Surat Izin Mengemudi', 'SIM', '');
/*!40000 ALTER TABLE `tb_sipil_jenis_id` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sipil_orang
CREATE TABLE IF NOT EXISTS `tb_sipil_orang` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `kode_sebutan` varchar(8) DEFAULT NULL,
  `nama_depan` varchar(32) NOT NULL,
  `nama_belakang` varchar(32) NOT NULL,
  `nama_lengkap` varchar(32) NOT NULL,
  `jenis_kelamin` char(1) NOT NULL,
  `tl_kode_geo_negara` varchar(8) DEFAULT NULL,
  `tl_kode_geo_provinsi` varchar(8) DEFAULT NULL,
  `tl_kode_geo_kabupaten` varchar(8) DEFAULT NULL,
  `tl_kode_geo_kecamatan` varchar(8) DEFAULT NULL,
  `tanggal_lahir` date NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `noID_UNIQUE` (`kode`),
  KEY `orang_kode_panggilan` (`kode_sebutan`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_sipil_orang: ~9 rows (approximately)
DELETE FROM `tb_sipil_orang`;
/*!40000 ALTER TABLE `tb_sipil_orang` DISABLE KEYS */;
INSERT INTO `tb_sipil_orang` (`nomor`, `kode`, `kode_sebutan`, `nama_depan`, `nama_belakang`, `nama_lengkap`, `jenis_kelamin`, `tl_kode_geo_negara`, `tl_kode_geo_provinsi`, `tl_kode_geo_kabupaten`, `tl_kode_geo_kecamatan`, `tanggal_lahir`, `catatan`) VALUES
	(1, 'OR0FTCHEGAAZSJNF', 'SBGY4H2W', 'Eka', 'Qadri Nuranti B', 'Eka Qadri Nuranti B', '0', 'NGUMARQ5', 'PVJKDRFY', 'KBJQTJAW', 'KCJWCSEK', '1992-02-10', ''),
	(2, 'ORBSXHXRB1T7KUFV', 'SBFYC4ER', 'Adrian', 'Setyadi', 'Adrian Setyadi', '1', 'NGUMARQ5', 'PVURVMN5', 'KBG5GRTS', 'KCKMUHNE', '1984-04-25', ''),
	(3, 'ORBPPXJM170MEQ5K', 'SBFYC4ER', 'I Made', 'Ariana', 'I Made Ariana', '1', 'NGUMARQ5', 'PVHGUWC8', 'KB9G0CX8', 'KCDQM0A8', '1982-07-10', ''),
	(4, 'ORMMWB1NCCW0SDSH', '', 'Ridwan', 'Kamil', 'Ridwan Kamil', '1', '', '', '', '', '1972-05-01', ''),
	(5, 'ORP5G8T5KBUEQ5EU', '', 'Joko', 'Widodo', 'Joko Widodo', '1', '', '', '', '', '1969-02-10', ''),
	(6, 'ORRZZGFNGDTNTNVW', '', 'Susilo Bambang', 'Yudhoyono', 'Susilo Bambang Yudhoyono', '1', '', '', '', '', '1957-05-06', ''),
	(7, 'ORYTV0MCWEC6D0W8', '', 'Yusuf', 'Kalla', 'Yusuf Kalla', '1', '', '', '', '', '1950-05-09', ''),
	(8, 'ORJTUFUWTVR66NRR', '', 'Lulung', 'Suryana', 'Lulung Suryana', '1', '', '', '', '', '1957-05-21', ''),
	(9, 'ORCWFD3S2PAH6XZC', '', 'Mitra', 'Yana', 'Mitra Yana', '0', '', '', '', '', '2015-05-06', ''),
	(10, 'ORSABG80K7CRXFUN', '', 'Surya', 'Paloh', 'Surya Paloh', '1', '', '', '', '', '1976-04-30', ''),
	(11, 'ORYZUMUUMQKM4M56', '', 'I Made', 'Ariana', 'I Made Ariana', '1', '', '', '', '', '1982-05-10', ''),
	(12, 'ORYNWMYK2VVRDHQ4', '', 'Rudi', 'Hartono', 'Rudi Hartono', '1', '', '', '', '', '1981-05-12', ''),
	(13, 'ORSMQSNB2GRPJ00X', '', 'Surya', 'Wibawa', 'Surya Wibawa', '1', '', '', '', '', '1982-05-12', ''),
	(14, 'ORXNKRBCWVJUR1VG', 'SBFYC4ER', 'Abd', 'Cde', 'Abd Cde', '1', 'NGUMARQ5', 'PVURVMN5', 'KBQMFYB2', 'KCYZU4GU', '1985-06-12', '');
/*!40000 ALTER TABLE `tb_sipil_orang` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sipil_orang_foto
CREATE TABLE IF NOT EXISTS `tb_sipil_orang_foto` (
  `nomor` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(16) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `nama_berkas` varchar(256) NOT NULL,
  `nama_berkas_asli` varchar(256) NOT NULL,
  `ekstensi` varchar(8) NOT NULL,
  `sampul` varchar(1) NOT NULL,
  `keterangan` text NOT NULL,
  `kode_sipil_orang` varchar(16) NOT NULL,
  PRIMARY KEY (`nomor`,`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table dbsispesanan.tb_sipil_orang_foto: ~2 rows (approximately)
DELETE FROM `tb_sipil_orang_foto`;
/*!40000 ALTER TABLE `tb_sipil_orang_foto` DISABLE KEYS */;
INSERT INTO `tb_sipil_orang_foto` (`nomor`, `kode`, `nama`, `nama_berkas`, `nama_berkas_asli`, `ekstensi`, `sampul`, `keterangan`, `kode_sipil_orang`) VALUES
	(6, 'FOFZZU68BMMBZWTT', 'Eka Qadri', '5Nq3xYUGhxNMvaabVwurdAaqRbyE8Rhca2ERMmf6BbPkdaFyJxk4cgEN', 'BzvhqYBCIAELaSf.jpg large.jpg', '.jpg', '1', '', 'OR0FTCHEGAAZSJNF'),
	(7, 'FOWPBZGN2RFQWQD0', 'Adrian Setyadi', 'tJuKc1n01g9yNxpmFNqmX5SS5QVpE8HY0E5eGCtvKFHQ0H94EvHXfy9H', '401232_10200714463081912_1743226598_n.jpg', '.jpg', '0', '', 'ORBSXHXRB1T7KUFV'),
	(8, 'FOHFUBPQSEMJTQHH', 'TEst', 'W2VBN1cUMKGSV2Zn3SgGPKZ8DnUedj36h1tUAsMMQ10jmfHUv8tMkW1b', 'Prof.-Tjandra_21.jpg', '.jpg', '0', '', 'ORBSXHXRB1T7KUFV'),
	(9, 'FOS2ERGJU3JUWWFW', 'Test', 'AGuFs3szY63GyevQTG1vGRfqQ2hbgcPSwqEdzuGRWjeRvB3sxGhN2Kun', '401232_10200714463081912_1743226598_n.jpg', '.jpg', '0', '', 'ORBSXHXRB1T7KUFV');
/*!40000 ALTER TABLE `tb_sipil_orang_foto` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sipil_sebutan
CREATE TABLE IF NOT EXISTS `tb_sipil_sebutan` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `nama` varchar(64) NOT NULL,
  `singkatan` varchar(16) NOT NULL,
  `jenis_kelamin` varchar(1) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_UNIQUE` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_sipil_sebutan: ~6 rows (approximately)
DELETE FROM `tb_sipil_sebutan`;
/*!40000 ALTER TABLE `tb_sipil_sebutan` DISABLE KEYS */;
INSERT INTO `tb_sipil_sebutan` (`nomor`, `kode`, `nama`, `singkatan`, `jenis_kelamin`, `catatan`) VALUES
	(1, 'SB44QG4P', 'Bapak', 'Bpk', '1', ''),
	(2, 'SBK8NBGX', 'Ibu', 'Ibu', '0', ''),
	(3, 'SBFYC4ER', 'Saudara', 'Sdr', '1', ''),
	(4, 'SBGY4H2W', 'Saudari', 'Sdri', '0', ''),
	(5, 'SBSAGPHC', 'Tuan', 'Tn', '1', ''),
	(6, 'SBURMWVA', 'Nyonya', 'Ny', '0', '');
/*!40000 ALTER TABLE `tb_sipil_sebutan` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_sistem
CREATE TABLE IF NOT EXISTS `tb_sistem` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_outlet` varchar(45) NOT NULL,
  `nama_outlet` varchar(32) NOT NULL,
  `alamat_negara` varchar(8) NOT NULL,
  `alamat_provinsi` varchar(8) NOT NULL,
  `alamat_kabupaten` varchar(8) NOT NULL,
  `alamat_kecamatan` varchar(8) NOT NULL,
  `alamat_jalan` varchar(8) NOT NULL,
  `kode_mata_uang` varchar(8) NOT NULL,
  `kode_gmt` varchar(8) NOT NULL,
  `catatan` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `sistem_kode_mata_uang` (`kode_mata_uang`),
  CONSTRAINT `sistem_kode_mata_uang` FOREIGN KEY (`kode_mata_uang`) REFERENCES `tb_fin_mata_uang` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_sistem: ~0 rows (approximately)
DELETE FROM `tb_sistem`;
/*!40000 ALTER TABLE `tb_sistem` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_sistem` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_telkom_telp_negara
CREATE TABLE IF NOT EXISTS `tb_telkom_telp_negara` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(8) NOT NULL,
  `kode_telepon` varchar(8) NOT NULL,
  `kode_negara` varchar(8) NOT NULL,
  `catatan` text,
  PRIMARY KEY (`nomor`,`kode`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  UNIQUE KEY `kode_telepon_UNIQUE` (`kode_telepon`),
  UNIQUE KEY `kode_negara_UNIQUE` (`kode_negara`),
  UNIQUE KEY `kode_UNIQUE` (`kode`),
  KEY `telkom_telp_negara_kode_geo_negara` (`kode_negara`),
  CONSTRAINT `telkom_telp_negara_kode_geo_negara` FOREIGN KEY (`kode_negara`) REFERENCES `tb_geo_negara` (`kode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_telkom_telp_negara: ~0 rows (approximately)
DELETE FROM `tb_telkom_telp_negara`;
/*!40000 ALTER TABLE `tb_telkom_telp_negara` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_telkom_telp_negara` ENABLE KEYS */;


-- Dumping structure for table dbsispesanan.tb_transaksi_jual
CREATE TABLE IF NOT EXISTS `tb_transaksi_jual` (
  `nomor` int(11) NOT NULL AUTO_INCREMENT,
  `kode_faktur_jual` varchar(16) NOT NULL,
  `kode_produk` varchar(8) NOT NULL,
  `kode_orang` varchar(16) NOT NULL,
  `harga_satuan` varchar(8) NOT NULL,
  `kuantitas` int(4) NOT NULL,
  `subtotal` varchar(9) NOT NULL,
  `catatan` text NOT NULL,
  `tanggal` varchar(10) NOT NULL,
  `jam` varchar(5) NOT NULL,
  `timestamp` varchar(128) NOT NULL,
  PRIMARY KEY (`nomor`),
  UNIQUE KEY `nomor_UNIQUE` (`nomor`),
  KEY `pesanan_kode_produk` (`kode_produk`),
  KEY `pesanan_kode_pelanggan` (`kode_orang`),
  KEY `pesanan_kode_faktur_jual` (`kode_faktur_jual`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Dumping data for table dbsispesanan.tb_transaksi_jual: ~10 rows (approximately)
DELETE FROM `tb_transaksi_jual`;
/*!40000 ALTER TABLE `tb_transaksi_jual` DISABLE KEYS */;
INSERT INTO `tb_transaksi_jual` (`nomor`, `kode_faktur_jual`, `kode_produk`, `kode_orang`, `harga_satuan`, `kuantitas`, `subtotal`, `catatan`, `tanggal`, `jam`, `timestamp`) VALUES
	(1, 'FKYFSGFGYPH4K414', 'PDWZPMCF', 'ORP5G8T5KBUEQ5EU', '18000.0', 1, '18000.0', '', '2015-06-12', '12:11', '1434085879'),
	(2, 'FKYFSGFGYPH4K414', 'PDMGXNPZ', 'ORP5G8T5KBUEQ5EU', '10000.0', 1, '10000.0', '', '2015-06-12', '12:11', '1434085879'),
	(3, 'FKYFSGFGYPH4K414', 'PDCDK03F', 'ORP5G8T5KBUEQ5EU', '25000.0', 1, '25000.0', '', '2015-06-12', '12:11', '1434085879'),
	(4, 'FKYFSGFGYPH4K414', 'PDMMKXW2', 'ORP5G8T5KBUEQ5EU', '32000.0', 1, '32000.0', '', '2015-06-12', '12:11', '1434085879'),
	(5, 'FKYFSGFGYPH4K414', 'PD261M4T', 'ORP5G8T5KBUEQ5EU', '18000.0', 1, '18000.0', '', '2015-06-12', '12:11', '1434085879'),
	(6, 'FKWSSNU8XBZH9CSR', 'PDWZPMCF', 'ORP5G8T5KBUEQ5EU', '18000.0', 1, '18000.0', '', '2015-06-12', '12:54', '1434088465'),
	(7, 'FKWSSNU8XBZH9CSR', 'PDMGXNPZ', 'ORP5G8T5KBUEQ5EU', '10000.0', 1, '10000.0', '', '2015-06-12', '12:54', '1434088465'),
	(8, 'FKWSSNU8XBZH9CSR', 'PDCDK03F', 'ORP5G8T5KBUEQ5EU', '25000.0', 1, '25000.0', '', '2015-06-12', '12:54', '1434088465'),
	(9, 'FKWSSNU8XBZH9CSR', 'PDMMKXW2', 'ORP5G8T5KBUEQ5EU', '32000.0', 1, '32000.0', '', '2015-06-12', '12:54', '1434088465'),
	(10, 'FKWSSNU8XBZH9CSR', 'PD261M4T', 'ORP5G8T5KBUEQ5EU', '18000.0', 1, '18000.0', '', '2015-06-12', '12:54', '1434088465'),
	(11, 'FKXVH4AUTQU3BFAC', 'PDWZPMCF', 'ORP5G8T5KBUEQ5EU', '18000.0', 1, '18000.0', '', '2015-06-12', '14:16', '1434093363'),
	(12, 'FKXVH4AUTQU3BFAC', 'PDMGXNPZ', 'ORP5G8T5KBUEQ5EU', '10000.0', 3, '30000.0', '', '2015-06-12', '14:16', '1434093363');
/*!40000 ALTER TABLE `tb_transaksi_jual` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
