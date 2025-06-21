--------------------------------------------------------
--  File created - Cuma-Haziran-13-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_LOG
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_LOG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 301 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_MUSTERI
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_MUSTERI"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_ODEME
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_ODEME"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_RESTORAN
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_RESTORAN"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SIPARISDETAY
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_SIPARISDETAY"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_URUN
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_URUN"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SIPARIS
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_SIPARIS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table KUPON
--------------------------------------------------------

  CREATE TABLE "KUPON" 
   (	"KUPON_KODU" VARCHAR2(20), 
	"ACIKLAMA" VARCHAR2(100), 
	"INDIRIM_ORANI" NUMBER(5,2), 
	"SON_KULLANMA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table LOGTABLO
--------------------------------------------------------

  CREATE TABLE "LOGTABLO" 
   (	"LOG_ID" NUMBER, 
	"ACIKLAMA" VARCHAR2(200), 
	"LOG_TARIH" DATE DEFAULT SYSDATE
   ) ;
--------------------------------------------------------
--  DDL for Table MUSTERI
--------------------------------------------------------

  CREATE TABLE "MUSTERI" 
   (	"MUSTERI_ID" NUMBER, 
	"ISIM" VARCHAR2(50), 
	"EMAIL" VARCHAR2(100), 
	"TELEFON" NUMBER(10,0), 
	"ADRES" VARCHAR2(200)
   ) ;
--------------------------------------------------------
--  DDL for Table ODEME
--------------------------------------------------------

  CREATE TABLE "ODEME" 
   (	"ODEME_ID" NUMBER, 
	"SIPARIS_ID" NUMBER, 
	"ODEME_TARIHI" DATE DEFAULT SYSDATE, 
	"ODENEN_TUTAR" NUMBER(10,2), 
	"KART_NUMARASI" VARCHAR2(16), 
	"GUVENLIK_KODU" VARCHAR2(4), 
	"KART_SAHIBI_ADSOYAD" VARCHAR2(100), 
	"SON_KULLANMA_TARIHI" VARCHAR2(5)
   ) ;
--------------------------------------------------------
--  DDL for Table RESTORAN
--------------------------------------------------------

  CREATE TABLE "RESTORAN" 
   (	"RESTORAN_ID" NUMBER, 
	"ISIM" VARCHAR2(100), 
	"ADRES" VARCHAR2(200), 
	"TELEFON" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table SIPARIS
--------------------------------------------------------

  CREATE TABLE "SIPARIS" 
   (	"SIPARIS_ID" NUMBER, 
	"MUSTERI_ID" NUMBER, 
	"RESTORAN_ID" NUMBER, 
	"SIPARIS_TARIHI" DATE DEFAULT SYSDATE, 
	"TOPLAM_TUTAR" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table SIPARISDETAY
--------------------------------------------------------

  CREATE TABLE "SIPARISDETAY" 
   (	"SIPARISDETAY_ID" NUMBER, 
	"SIPARIS_ID" NUMBER, 
	"URUN_ID" NUMBER, 
	"ADET" NUMBER, 
	"FIYAT" NUMBER(8,2), 
	"YORUM" VARCHAR2(500), 
	"PUAN" NUMBER(1,0), 
	"DURUM" VARCHAR2(50), 
	"GUNCELLEME_TARIHI" DATE DEFAULT SYSDATE, 
	"KOMISYON" NUMBER(8,2)
   ) ;
--------------------------------------------------------
--  DDL for Table URUN
--------------------------------------------------------

  CREATE TABLE "URUN" 
   (	"URUN_ID" NUMBER, 
	"RESTORAN_ID" NUMBER, 
	"AD" VARCHAR2(100), 
	"FIYAT" NUMBER(8,2)
   ) ;
--------------------------------------------------------
--  DDL for View VWC_MUSTERI_SIPARIS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VWC_MUSTERI_SIPARIS" ("MUSTERI_ADI", "EMAIL", "SIPARIS_ID", "SIPARIS_TARIHI", "URUN_ADI", "ADET", "FIYAT", "TOPLAM_TUTAR") AS 
  SELECT 
    m.isim AS musteri_adi,
    m.email,
    s.siparis_id,
    s.siparis_tarihi,
    u.ad AS urun_adi,
    sd.adet,
    sd.fiyat,
    s.toplam_tutar
FROM Musteri m
JOIN Siparis s ON m.musteri_id = s.musteri_id
JOIN SiparisDetay sd ON s.siparis_id = sd.siparis_id
JOIN Urun u ON sd.urun_id = u.urun_id
;
--------------------------------------------------------
--  DDL for View VW_RESTORAN_URUNLERI
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RESTORAN_URUNLERI" ("RESTORAN_ADI", "URUN_ADI", "FIYAT") AS 
  SELECT r.isim AS restoran_adi, u.ad AS urun_adi, u.fiyat
FROM Urun u
JOIN Restoran r ON u.restoran_id = r.restoran_id
;
--------------------------------------------------------
--  DDL for View VW_YORUM_PUAN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_YORUM_PUAN" ("SIPARIS_ID", "URUN_ID", "URUN_ADI", "RESTORAN_ADI", "MUSTERI_ADI", "YORUM", "PUAN", "SIPARIS_TARIHI") AS 
  SELECT
    sd.siparis_id,
    sd.urun_id,
    u.ad AS urun_adi,
    r.isim AS restoran_adi,
    m.isim AS musteri_adi,
    sd.yorum,
    sd.puan,
    s.siparis_tarihi
FROM SiparisDetay sd
JOIN Siparis s ON sd.siparis_id = s.siparis_id
JOIN Urun u ON sd.urun_id = u.urun_id
JOIN Restoran r ON u.restoran_id = r.restoran_id
JOIN Musteri m ON s.musteri_id = m.musteri_id
WHERE sd.yorum IS NOT NULL OR sd.puan IS NOT NULL
;


--------------------------------------------------------
--  DDL for Index IDX_SIPARIS_MUSTERI
--------------------------------------------------------

  CREATE INDEX "IDX_SIPARIS_MUSTERI" ON "SIPARIS" ("MUSTERI_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_URUN_RESTORAN
--------------------------------------------------------

  CREATE INDEX "IDX_URUN_RESTORAN" ON "URUN" ("RESTORAN_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007281
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007281" ON "KUPON" ("KUPON_KODU") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007266
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007266" ON "LOGTABLO" ("LOG_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007255
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007255" ON "MUSTERI" ("MUSTERI_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007256
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007256" ON "MUSTERI" ("EMAIL") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007276
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007276" ON "ODEME" ("ODEME_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007273
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007273" ON "RESTORAN" ("RESTORAN_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007260
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007260" ON "SIPARIS" ("SIPARIS_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_SIPARIS_MUSTERI
--------------------------------------------------------

  CREATE INDEX "IDX_SIPARIS_MUSTERI" ON "SIPARIS" ("MUSTERI_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007263
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007263" ON "SIPARISDETAY" ("SIPARISDETAY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007258
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007258" ON "URUN" ("URUN_ID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_URUN_RESTORAN
--------------------------------------------------------

  CREATE INDEX "IDX_URUN_RESTORAN" ON "URUN" ("RESTORAN_ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TRG_ADET_KONTROL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_ADET_KONTROL" 
BEFORE INSERT OR UPDATE ON SiparisDetay
FOR EACH ROW
BEGIN
    IF :NEW.adet <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Adet 0 veya daha küçük olamaz.');
    END IF;
END;
/
ALTER TRIGGER "TRG_ADET_KONTROL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DETAY_FIYAT_VE_KOMISYON
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DETAY_FIYAT_VE_KOMISYON" 
BEFORE INSERT OR UPDATE ON SiparisDetay
FOR EACH ROW
DECLARE
    v_birim_fiyat NUMBER;
BEGIN
    -- Ürün fiyatýný getir
    SELECT fiyat INTO v_birim_fiyat FROM Urun WHERE urun_id = :NEW.urun_id;

    -- Toplam fiyat hesapla
    :NEW.fiyat := v_birim_fiyat * :NEW.adet;

    -- Komisyonu hesapla (yüzde 25)
    :NEW.komisyon := :NEW.fiyat * 0.25;
END;

/
ALTER TRIGGER "TRG_DETAY_FIYAT_VE_KOMISYON" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ODEME
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_ODEME" BEFORE INSERT ON Odeme
FOR EACH ROW
DECLARE
    v_toplam NUMBER(10, 2);
BEGIN
    SELECT SUM(fiyat)
    INTO v_toplam
    FROM SiparisDetay
    WHERE siparis_id = :NEW.siparis_id;

    :NEW.odenen_tutar := v_toplam;
    :NEW.odeme_id := seq_odeme.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_ODEME" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_SIPARISDETAY_DURUM
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_SIPARISDETAY_DURUM" 
BEFORE INSERT ON SiparisDetay
FOR EACH ROW
BEGIN
    IF :NEW.durum IS NULL THEN
        :NEW.durum := 'Hazýrlanýyor';
    END IF;

    IF :NEW.guncelleme_tarihi IS NULL THEN
        :NEW.guncelleme_tarihi := SYSDATE;
    END IF;
END;

/
ALTER TRIGGER "TRG_SIPARISDETAY_DURUM" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_SIPARIS_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_SIPARIS_LOG" 
AFTER INSERT ON Siparis
FOR EACH ROW
BEGIN
    END;

/
ALTER TRIGGER "TRG_SIPARIS_LOG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG__SIPARISDETAY_ID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG__SIPARISDETAY_ID" 
BEFORE INSERT ON SiparisDetay
FOR EACH ROW
DECLARE
    v_max_id NUMBER;
BEGIN
    IF :NEW.siparisdetay_id IS NULL THEN
        SELECT NVL(MAX(siparisdetay_id), 0) + 1 INTO v_max_id FROM SiparisDetay;
        :NEW.siparisdetay_id := v_max_id;
    END IF;
END;

/
ALTER TRIGGER "TRG__SIPARISDETAY_ID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ODEME
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_ODEME" BEFORE INSERT ON Odeme
FOR EACH ROW
DECLARE
    v_toplam NUMBER(10, 2);
BEGIN
    SELECT SUM(fiyat)
    INTO v_toplam
    FROM SiparisDetay
    WHERE siparis_id = :NEW.siparis_id;

    :NEW.odenen_tutar := v_toplam;
    :NEW.odeme_id := seq_odeme.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_ODEME" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_SIPARIS_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_SIPARIS_LOG" 
AFTER INSERT ON Siparis
FOR EACH ROW
BEGIN
    END;

/
ALTER TRIGGER "TRG_SIPARIS_LOG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ADET_KONTROL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_ADET_KONTROL" 
BEFORE INSERT OR UPDATE ON SiparisDetay
FOR EACH ROW
BEGIN
    IF :NEW.adet <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Adet 0 veya daha küçük olamaz.');
    END IF;
END;
/
ALTER TRIGGER "TRG_ADET_KONTROL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG__SIPARISDETAY_ID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG__SIPARISDETAY_ID" 
BEFORE INSERT ON SiparisDetay
FOR EACH ROW
DECLARE
    v_max_id NUMBER;
BEGIN
    IF :NEW.siparisdetay_id IS NULL THEN
        SELECT NVL(MAX(siparisdetay_id), 0) + 1 INTO v_max_id FROM SiparisDetay;
        :NEW.siparisdetay_id := v_max_id;
    END IF;
END;

/
ALTER TRIGGER "TRG__SIPARISDETAY_ID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_SIPARISDETAY_DURUM
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_SIPARISDETAY_DURUM" 
BEFORE INSERT ON SiparisDetay
FOR EACH ROW
BEGIN
    IF :NEW.durum IS NULL THEN
        :NEW.durum := 'Hazýrlanýyor';
    END IF;

    IF :NEW.guncelleme_tarihi IS NULL THEN
        :NEW.guncelleme_tarihi := SYSDATE;
    END IF;
END;

/
ALTER TRIGGER "TRG_SIPARISDETAY_DURUM" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DETAY_FIYAT_VE_KOMISYON
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DETAY_FIYAT_VE_KOMISYON" 
BEFORE INSERT OR UPDATE ON SiparisDetay
FOR EACH ROW
DECLARE
    v_birim_fiyat NUMBER;
BEGIN
    -- Ürün fiyatýný getir
    SELECT fiyat INTO v_birim_fiyat FROM Urun WHERE urun_id = :NEW.urun_id;

    -- Toplam fiyat hesapla
    :NEW.fiyat := v_birim_fiyat * :NEW.adet;

    -- Komisyonu hesapla (yüzde 25)
    :NEW.komisyon := :NEW.fiyat * 0.25;
END;

/
ALTER TRIGGER "TRG_DETAY_FIYAT_VE_KOMISYON" ENABLE;
--------------------------------------------------------
--  DDL for Procedure MUSTERI_EKLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "MUSTERI_EKLE" (
    p_isim IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefon IN VARCHAR2,
    p_adres IN VARCHAR2
) IS
BEGIN
    END;

/
--------------------------------------------------------
--  DDL for Procedure RESTORAN_EKLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "RESTORAN_EKLE" (
    p_isim IN VARCHAR2,
    p_adres IN VARCHAR2,
    p_telefon IN VARCHAR2
) IS
BEGIN
    END;

/
--------------------------------------------------------
--  DDL for Procedure SIPARIS_EKLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SIPARIS_EKLE" (
    p_musteri_id IN NUMBER,
    p_restoran_id IN NUMBER,
    p_yemekler IN SYS.ODCINUMBERLIST,
    p_adetler IN SYS.ODCINUMBERLIST
) IS
    v_siparis_id NUMBER;
    v_fiyat NUMBER;
    v_toplam NUMBER := 0;
BEGIN
    -- Yeni sipariþi oluþtur
    v_siparis_id := seq_siparis.NEXTVAL;
    -- Her yemek için sipariþ detayý ekle
    FOR i IN 1 .. p_yemekler.COUNT LOOP
        SELECT fiyat INTO v_fiyat FROM Yemek WHERE yemek_id = p_yemekler(i);

        v_toplam := v_toplam + (v_fiyat * p_adetler(i));
    END LOOP;

    -- Sipariþin toplam tutarýný güncelle
    UPDATE Siparis
    SET toplam_tutar = v_toplam
    WHERE siparis_id = v_siparis_id;

    COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Function MUSTERI_SIPARIS_SAYISI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "MUSTERI_SIPARIS_SAYISI" (p_musteri_id NUMBER) RETURN NUMBER IS
    v_sayi NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_sayi FROM Siparis WHERE musteri_id = p_musteri_id;
    RETURN v_sayi;
END;

/
--------------------------------------------------------
--  DDL for Function RESTORAN_ORTALAMA_PUAN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "RESTORAN_ORTALAMA_PUAN" (p_restoran_id NUMBER)
RETURN NUMBER
IS
    v_ortalama NUMBER := 0;
BEGIN
    SELECT NVL(AVG(sd.puan), 0)
    INTO v_ortalama
    FROM SiparisDetay sd
    JOIN Urun u ON sd.urun_id = u.urun_id
    WHERE u.restoran_id = p_restoran_id
      AND sd.puan IS NOT NULL;

    RETURN v_ortalama;
END;

/
--------------------------------------------------------
--  DDL for Function RESTORAN_TOPLAM_KOMISYON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "RESTORAN_TOPLAM_KOMISYON" (p_restoran_id NUMBER)
RETURN NUMBER
IS
    v_komisyon NUMBER := 0;
BEGIN
    SELECT NVL(SUM(sd.komisyon), 0)
    INTO v_komisyon
    FROM SiparisDetay sd
    JOIN Urun u ON sd.urun_id = u.urun_id
    WHERE u.restoran_id = p_restoran_id;

    RETURN v_komisyon;
END;

/
--------------------------------------------------------
--  DDL for Function RESTORAN_TOPLAM_SATIS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "RESTORAN_TOPLAM_SATIS" (p_restoran_id NUMBER) RETURN NUMBER IS
    v_toplam NUMBER;
BEGIN
    SELECT NVL(SUM(toplam_tutar), 0) INTO v_toplam
    FROM Siparis
    WHERE restoran_id = p_restoran_id;
    RETURN v_toplam;
END;

/
--------------------------------------------------------
--  Constraints for Table KUPON
--------------------------------------------------------

  ALTER TABLE "KUPON" ADD PRIMARY KEY ("KUPON_KODU") ENABLE;
--------------------------------------------------------
--  Constraints for Table LOGTABLO
--------------------------------------------------------

  ALTER TABLE "LOGTABLO" ADD PRIMARY KEY ("LOG_ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table MUSTERI
--------------------------------------------------------

  ALTER TABLE "MUSTERI" ADD UNIQUE ("EMAIL") ENABLE;
  ALTER TABLE "MUSTERI" ADD PRIMARY KEY ("MUSTERI_ID") ENABLE;
  ALTER TABLE "MUSTERI" ADD CONSTRAINT "CHK_TELEFON_FORMAT" CHECK (telefon BETWEEN 5000000000 AND 5999999999) ENABLE;
--------------------------------------------------------
--  Constraints for Table ODEME
--------------------------------------------------------

  ALTER TABLE "ODEME" ADD PRIMARY KEY ("ODEME_ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table RESTORAN
--------------------------------------------------------

  ALTER TABLE "RESTORAN" ADD PRIMARY KEY ("RESTORAN_ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table SIPARIS
--------------------------------------------------------

  ALTER TABLE "SIPARIS" ADD PRIMARY KEY ("SIPARIS_ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table SIPARISDETAY
--------------------------------------------------------

  ALTER TABLE "SIPARISDETAY" ADD CONSTRAINT "CHK_PUAN_RANGE" CHECK (puan BETWEEN 1 AND 5) ENABLE;
  ALTER TABLE "SIPARISDETAY" ADD PRIMARY KEY ("SIPARISDETAY_ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table URUN
--------------------------------------------------------

  ALTER TABLE "URUN" ADD PRIMARY KEY ("URUN_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ODEME
--------------------------------------------------------

  ALTER TABLE "ODEME" ADD FOREIGN KEY ("SIPARIS_ID")
	  REFERENCES "SIPARIS" ("SIPARIS_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SIPARIS
--------------------------------------------------------

  ALTER TABLE "SIPARIS" ADD FOREIGN KEY ("MUSTERI_ID")
	  REFERENCES "MUSTERI" ("MUSTERI_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SIPARISDETAY
--------------------------------------------------------

  ALTER TABLE "SIPARISDETAY" ADD FOREIGN KEY ("SIPARIS_ID")
	  REFERENCES "SIPARIS" ("SIPARIS_ID") ENABLE;
  ALTER TABLE "SIPARISDETAY" ADD FOREIGN KEY ("URUN_ID")
	  REFERENCES "URUN" ("URUN_ID") ENABLE;
