---ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

---su dung user system
---CUAHANGSACH
create table CUAHANG(
    MACH VARCHAR2(255) PRIMARY KEY,
    TENCH NVARCHAR2(255),
    DIACHI NVARCHAR2(255)
)
/
create table KHACHHANG(
    MAKH VARCHAR2(255) PRIMARY KEY,
    TENKH NVARCHAR2(255),
    SDT VARCHAR(20),
    DIACHI NVARCHAR2(255)
)
/
create table SACH(
    MASACH VARCHAR2(255) PRIMARY KEY,
    TENSACH NVARCHAR2(255),
    GIABAN INT
)
/
create table HOADON(
    MAHD VARCHAR2(255) PRIMARY KEY,
    MAKH VARCHAR2(255),
    NGAYLAP DATE,
    TONGTIEN INT DEFAULT 0,
    MACH VARCHAR2(255),
    CONSTRAINT FK_HD_KH FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH),
    CONSTRAINT FK_HD_CH FOREIGN KEY(MACH) REFERENCES CUAHANG(MACH)
)
/
create table CTCH(
    MACH VARCHAR2(255),
    MASACH VARCHAR2(255),
    SLG_TON INT,
    CONSTRAINT SK_CTCH PRIMARY KEY(MACH,MASACH),
    CONSTRAINT FK_CTCH_CH FOREIGN KEY(MACH) REFERENCES CUAHANG(MACH),
    CONSTRAINT FK_CTCH_SACH FOREIGN KEY(MASACH) REFERENCES SACH(MASACH)
)
/
create table CTHD(
    MAHD VARCHAR2(255),
    MASACH VARCHAR2(255),
    SLG_BAN INT,
    CONSTRAINT SK_CTHD PRIMARY KEY(MAHD, MASACH),
    CONSTRAINT FK_CTHD_HD FOREIGN KEY(MAHD) REFERENCES HOADON(MAHD),
    CONSTRAINT FK_CTHD_SACH FOREIGN KEY(MASACH) REFERENCES SACH(MASACH)
)
/
---thu tuc xem ctch cua 1 cua hang
create or replace procedure p_xem_ctch(
    cur_ctch OUT sys_refcursor
)
is
begin
    open cur_ctch for
        select *
        from system.ctch;
end;
/
---thu tuc them 1 chi tiet cua hang
create or replace procedure p_them_ctch(
    in_mach IN varchar2,
    in_masach IN varchar2,
    in_slgton IN int
)
is 
begin
    ---them tai site cuc bo
    insert into system.ctch(mach, masach, slg_ton)
    values(in_mach, in_masach, in_slgton);
    ---them vao site chu
    insert into system.ctch@CHS_DBLINK(mach, masach, slg_ton)
    values(in_mach, in_masach, in_slgton);
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc chinh sua 1 chi tiet cua hang
create or replace procedure p_sua_ctch(
    in_mach IN varchar2,
    in_masach IN varchar2,
    in_slgton IN int
)
is 
begin
    ---chinh sua site cuc bo
    update system.ctch 
    set slg_ton=in_slgton
    where mach =in_mach and masach=in_masach;
    ---chinh sua site chu
    update system.ctch@CHS_DBLINK 
    set slg_ton=in_slgton
    where mach =in_mach and masach=in_masach;
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc xoa 1 chi tiet cua hang
create or replace procedure p_xoa_ctch(
    in_mach IN varchar2,
    in_masach IN varchar2
)
is 
begin
    ---xoa o site cuc bo
    delete from system.ctch
    where mach=in_mach and masach=in_masach;
    ---xoa o site chu
    delete from system.ctch@CHS_DBLINK
    where mach=in_mach and masach=in_masach;
    commit;
    exception
        when others then
        rollback;
end;
/
---KHACHHANG
---thu tuc tim khach hang
create or replace procedure p_tim_kh(
    cur_kh OUT sys_refcursor,
    in_makh IN varchar2,
    in_tenkh IN nvarchar2
)
is 
begin
    open cur_kh for 
    select * from system.khachhang
    where makh=in_makh or tenkh like '%'||in_tenkh||'%';
end;
/
---thu tuc them khach hang
create or replace procedure p_them_kh(
    in_makh IN varchar2,
    in_tenkh IN nvarchar2,
    in_sdt varchar2,
    in_diachi nvarchar2
)
is 
begin
    ---them vao site cuc bo
    insert into system.khachhang(makh, tenkh, sdt, diachi)
    values(in_makh, in_tenkh, in_sdt, in_diachi);
    ---them vao site chu
    insert into system.khachhang@CHS_DBLINK(makh, tenkh, sdt, diachi)
    values(in_makh, in_tenkh, in_sdt, in_diachi);
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc sua khach hang
create or replace procedure p_sua_kh(
    in_makh IN varchar2,
    in_tenkh IN nvarchar2,
    in_sdt varchar2,
    in_diachi nvarchar2
)
is 
begin
    ---sua tai site cuc bo
    update system.khachhang
    set tenkh=in_tenkh, sdt=in_sdt, diachi=in_diachi
    where makh=in_makh;
    ---sua tai site chu
    update system.khachhang@CHS_DBLINK
    set tenkh=in_tenkh, sdt=in_sdt, diachi=in_diachi
    where makh=in_makh;
    commit;
    exception
        when others then
        rollback;
end;
/
---SACH
---thu tuc tim sach
create or replace procedure p_tim_sach(
    cur_sach out sys_refcursor,
    in_tensach in nvarchar2
)
is
begin
    open cur_sach for
        select s.masach, s.tensach, s.giaban, c.slg_ton
        from system.sach s, system.ctch c
        where s.masach=c.masach
end;
/
---thu tuc them thong tin 1 tua sach
create or replace procedure p_them_sach(
    in_masach in varchar2,
    in_tensach in nvarchar2,
    in_giaban int
)
is
begin
    ---them vao site cuc bo
    insert into system.sach(masach, tensach, giaban)
    values(in_masach, in_tensach, in_giaban);
    ---them vao site chu
    insert into system.sach@CHS_DBLINK(masach, tensach, giaban)
    values(in_masach, in_tensach, in_giaban);
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc sua sach
create or replace procedure p_sua_sach(
    in_masach in varchar2,
    in_tensach in nvarchar2,
    in_giaban int
)
is
begin
    ---sua tai site cuc bo
    update system.sach
    set tensach=in_tensach, giaban=in_giaban
    where masach=in_masach;
    ---sua tai site chu
    update system.sach@CHS_DBLINK
    set tensach=in_tensach, giaban=in_giaban
    where masach=in_masach;
    commit;
    exception
        when others then
        rollback;
end;
---HOADON
---ham tao ma hoadon danh cho site cuc bo
create or replace function f_tao_ma_hd
return varchar2
is 
    v_mach varchar2(255);
    v_count number;
    v_dem_hd number; 
    v_mahd varchar2(255);
begin
    select mach into v_mach from system.cuahang;
    select count(*) into v_count from system.hoadon;
    v_dem_hd:=v_count+1;
    v_mahd:=v_mach||'HD'||to_char(v_dem_hd);
return v_mahd;
end;
/
select system.f_tao_ma_hd() from dual;
---thu tuc tim hoa don
create or replace procedure p_tim_hd(
    cur_hd OUT sys_refcursor,
    in_mahd IN varchar2,
    in_makh IN varchar2
)
is
begin
    ---tim truc tiep o site chu
    open cur_hd for 
    select * from system.hoadon@CHS_DBLINK
    where mahd=in_mahd or makh=in_makh;
end;
/
---thu tuc them hoa don
create or replace procedure p_tao_hd(
    in_mahd IN varchar2,
    in_makh IN varchar2,
    in_ngaylap date
)
is
    v_mach varchar2(255);
begin    
    select mach into v_mach from system.cuahang;
    ---them tai site cuc bo
    insert into system.hoadon(mahd, makh, ngaylap, mach)
    values(in_mahd, in_makh, to_date(in_ngaylap,'DD/MM/YYYY'), v_mach);
    ---them tai site chu
    insert into system.hoadon@CHS_DBLINK(mahd, makh, ngaylap, mach)
    values(in_mahd, in_makh, to_date(in_ngaylap,'DD/MM/YYYY'), v_mach);
    commit;
    exception
        when others then
        rollback;
end;
/
---CTHD
---thu tuc xem chi tiet hoa don theo ma hoa don
create or replace procedure p_xem_cthd(
    cur_cthd OUT sys_refcursor,
    in_mahd IN varchar2
)
is 
begin
    open cur_cthd for
    select c.mahd, c.masach, s.tensach, c.slg_ban
    from system.cthd@CHS_DBLINK c, system.sach s
    where mahd=in_mahd and c.masach=s.tensach;
end;
/
---thu tuc them chi tiet hoa don
create or replace procedure p_them_cthd(
    in_mahd IN varchar2,
    in_masach IN varchar2,
    in_slgban IN int
)
is
    v_mach varchar2(255);
begin
    select mach into v_mach from system.cuahang;
    ---them vao site cuc bo
    insert into system.cthd(mahd, masach, slg_ban)
    values(in_mahd, in_masach, in_slgban);
    ---cap nhat so luong sach tai cua hang do
    update system.ctch
    set slg_ton=slg_ton-in_slgban
    where mach=v_mach and masach=in_masach;
    ---them vao site chu
    insert into system.cthd@CHS_DBLINK(mahd, masach, slg_ban)
    values(in_mahd, in_masach, in_slgban);
    ---cap nhat so luong sach tai site chu
    update system.ctch@CHS_DBLINK
    set slg_ton=slg_ton-in_slgban
    where mach=v_mach and masach=in_masach;
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc xoa cthd
create or replace procedure p_xoa_cthd(
    in_mahd IN varchar2,
    in_masach IN varchar2,
    in_slgban IN int
)
is
    v_mach varchar2(255);
begin
    select mach into v_mach from system.cuahang;
    ---xoa site cuc bo
    delete from system.cthd
    where mahd=in_mahd and masach=in_masach;
    ---cap nhat lai so luong tai site cuc bo
    update system.ctch
    set slg_ton=slg_ton+in_slgban
    where mach=v_mach and masach=in_masach;
    ---xoa tai site chu
    delete from system.cthd@CHS_DBLINK
    where mahd=in_mahd and masach=in_masach;
    ---cap nhat lai so luong tai site chu    
    update system.ctch@CHS_DBLINK
    set slg_ton=slg_ton+in_slgban
    where mach=v_mach and masach=in_masach;
    commit;
    exception
        when others then
        rollback;
end;
/
---du lieu
insert into system.cuahang(mach, tench, diachi)
values('CH01',N'C?a hàng 01',N'Qu?n 1');
---
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVA',N'Nguy?n V?n A','0909000001',N'Qu?n Gò V?p');
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVB',N'Nguy?n V?n B','0909000002',N'Qu?n Bình Th?nh');
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVC',N'Nguy?n V?n C','0909000003',N'Qu?n 1');
---
insert into system.sach(masach, tensach, giaban)
values('S001',N'Nhà Gi? Kim',45000);
insert into system.sach(masach, tensach, giaban)
values('S002',N'Tony trên ???ng b?ng', 50000);
insert into system.sach(masach, tensach, giaban)
values('S003',N'Chi?c lá cu?i cùng',75000);
---
insert into system.ctch(mach, masach, slg_ton)
values('CH01','S001',100);
insert into system.ctch(mach, masach, slg_ton)
values('CH01','S002',50);
insert into system.ctch(mach, masach, slg_ton)
values('CH01','S003',200);
---
select system.f_tao_ma_hd from dual;
execute system.p_tao_hd('CH01HD1','NVA',to_date('01/11/2023','DD/MM/YYYY'));
/
select * from system.hoadon;
