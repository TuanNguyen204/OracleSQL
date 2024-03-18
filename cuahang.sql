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
/*---du lieu cua hang
---cuahang1
insert into system.cuahang(mach, tench, diachi)
values('CH01',N'C?a hàng 01',N'Qu?n 1');
---cuahang2
insert into system.cuahang(mach, tench, diachi)
values('CH02',N'C?a hàng 02',N'Qu?n 2');
---du lieu khach hang
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVA',N'Nguy?n V?n A','0909000001',N'Qu?n Gò V?p');
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVB',N'Nguy?n V?n B','0909000002',N'Qu?n Bình Th?nh');
insert into system.khachhang(makh, tenkh, sdt, diachi)
values('NVC',N'Nguy?n V?n C','0909000003',N'Qu?n 1');
---du lieu sach
insert into system.sach(masach, tensach, giaban)
values('SACH1',N'Nhà Gi? Kim',45000);
insert into system.sach(masach, tensach, giaban)
values('SACH2',N'Tony trên ???ng b?ng', 50000);
insert into system.sach(masach, tensach, giaban)
values('SACH3',N'Chi?c lá cu?i cùng',75000);
---du lieu hoadon
---hoa don cua cua hang 1
insert into system.hoadon(mahd, makh, ngaylap, mach)
values('CH01HD1','NVA',to_date('01/11/2023','DD/MM/YYYY'),'CH01');
insert into system.hoadon(mahd, makh, ngaylap, mach)
values('CH01HD2','NVB',to_date('01/11/2023','DD/MM/YYYY'),'CH01');
insert into system.hoadon(mahd, makh, ngaylap, mach)
values('CH02HD1','NVC',to_date('01/11/2023','DD/MM/YYYY'),'CH02');
SELECT * FROM HOADON;
---du lieu chi tiet cua hang
insert into system.ctch(mach, masach, slg_ton)
values('CH01','SACH1',100);
insert into system.ctch(mach, masach, slg_ton)
values('CH01','SACH2',50);
insert into system.ctch(mach, masach, slg_ton)
values('CH01','SACH3',200);
insert into system.ctch(mach, masach, slg_ton)
values('CH02','SACH1',100);
insert into system.ctch(mach, masach, slg_ton)
values('CH02','SACH2',100);
insert into system.ctch(mach, masach, slg_ton)
values('CH02','SACH3',100);
select * from ctch;
---du lieu chi tiet hoa don
insert into system.cthd(mahd, masach, slg_ban)
values('CH01HD1','SACH1',1);
insert into system.cthd(mahd, masach, slg_ban)
values('CH01HD2','SACH3',1);
insert into system.cthd(mahd, masach, slg_ban)
values('CH01HD2','SACH2',1);
insert into system.cthd(mahd, masach, slg_ban)
values('CH02HD1','SACH1',1);
insert into system.cthd(mahd, masach, slg_ban)
values('CH02HD1','SACH3',1);
select * from cthd;
*/
--- database link 
---ket noi tu site phan manh den site chu
---cuahangsach1
create public database link CHS1_DBLINK
CONNECT TO system IDENTIFIED BY system123
USING 'CUAHANGSACH1';
---cuahangsach2
create public database link CHS2_DBLINK
CONNECT TO system IDENTIFIED BY system123
USING 'CUAHANGSACH2';
---
/*USING '(DESCRIPTION=
                (ADDRESS=(PROTOCOL=TCP)(HOST=)(PORT=1521))
                (CONNECT_DATA=(SERVICE_NAME=CUAHANGSACH))
            )';
*/

/
---thu tuc xem ctch cua 1 cua hang
create or replace procedure p_xem_ctch(
    cur_ctch OUT sys_refcursor,
    in_mach IN varchar2,
    in_masach IN varchar2
)
is
begin
    if in_masach is null then
        if in_mach ='ALL' then
            open cur_ctch for 
            select * from ctch;
        else 
            open cur_ctch for 
            select * from ctch
            where mach=in_mach;
        end if;
    else
        if in_mach ='ALL' then
            open cur_ctch for 
            select * from ctch
            where masach=in_masach;
        else 
            open cur_ctch for 
            select * from ctch
            where mach=in_mach and masach=in_masach;
        end if;
    end if;
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
    ---them tai site chu
    insert into system.ctch(mach, masach, slg_ton)
    values(in_mach, in_masach, in_slgton);
    ---them vao site1
    if in_mach='CH01' then
        insert into system.ctch@CHS1_DBLINK(mach, masach, slg_ton)
        values(in_mach, in_masach, in_slgton);
    else
    ---them vao site2
        insert into system.ctch@CHS2_DBLINK(mach, masach, slg_ton)
        values(in_mach, in_masach, in_slgton);
    end if;
    ---
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
    ---chinh sua site chu
    update system.ctch 
    set slg_ton=in_slgton
    where mach =in_mach and masach=in_masach;
    ---chinh sua site1
    if in_mach='CH01' then
        update system.ctch@CHS1_DBLINK 
        set slg_ton=in_slgton
        where mach =in_mach and masach=in_masach;
    ---chinh sua site2
    else
        update system.ctch@CHS2_DBLINK 
        set slg_ton=in_slgton
        where mach =in_mach and masach=in_masach;
    end if;
    ---
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
    ---xoa o site chu
    delete from system.ctch
    where mach=in_mach and masach=in_masach;    
    ---xoa o site1
    if in_mach='CH01' then
        delete from system.ctch@CHS1_DBLINK
        where mach=in_mach and masach=in_masach;
    ---xoa o site2
    else
        delete from system.ctch@CHS2_DBLINK
        where mach=in_mach and masach=in_masach;
    end if;
    ---
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
    if in_makh is null and in_tenkh is null then
        open cur_kh for 
            select *
            from system.khachhang;
    elsif in_makh is not null and in_tenkh is null then
        open cur_kh for 
            select *
            from system.khachhang
            where makh=in_makh;
    elsif in_makh is null and in_tenkh is not null then
        open cur_kh for 
            select *
            from system.khachhang
            where tenkh like '%'||in_tenkh||'%';
    else
        open cur_kh for 
            select *
            from system.khachhang
            where makh=in_makh and tenkh like '%'||in_tenkh||'%';
    end if;
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
    ---them vao site chu
    insert into system.khachhang(makh, tenkh, sdt, diachi)
    values(in_makh, in_tenkh, in_sdt, in_diachi);
    ---them vao site 1
    insert into system.khachhang@CHS1_DBLINK(makh, tenkh, sdt, diachi)
    values(in_makh, in_tenkh, in_sdt, in_diachi);
    ---them vao site 2
    insert into system.khachhang@CHS2_DBLINK(makh, tenkh, sdt, diachi)
    values(in_makh, in_tenkh, in_sdt, in_diachi);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
---thu tuc cap nhat khach hang
create or replace procedure p_cap_nhat_kh(
    in_makh IN varchar2,
    in_tenkh IN nvarchar2,
    in_sdt varchar2,
    in_diachi nvarchar2
)
is 
begin
    ---sua tai site chu
    update system.khachhang
    set tenkh=in_tenkh, sdt=in_sdt, diachi=in_diachi
    where makh=in_makh;
    ---sua tai site 1
    update system.khachhang@CHS1_DBLINK
    set tenkh=in_tenkh, sdt=in_sdt, diachi=in_diachi
    where makh=in_makh;
    ---sua tai site 2
    update system.khachhang@CHS2_DBLINK
    set tenkh=in_tenkh, sdt=in_sdt, diachi=in_diachi
    where makh=in_makh;
    ---
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
        select * from sach
        where tensach like '%'||in_tensach||'%';
end;
/
---ham tao ma sach
create or replace function f_tao_ma_sach
return varchar2
is 
    v_count number:=0;
    v_masach varchar2(255);
begin
    select count(*) into v_count from system.sach;
    v_count:=v_count+1;
    v_masach:='SACH'||to_char(v_count);
return v_masach;
end;
/
---select system.f_tao_ma_sach from dual;
---thu tuc them thong tin 1 tua sach
create or replace procedure p_them_sach(
    in_masach in varchar2,
    in_tensach in nvarchar2,
    in_giaban int
)
is
begin
    ---them vao site chu
    insert into system.sach(masach, tensach, giaban)
    values(in_masach, in_tensach, in_giaban);
    ---them vao site 1
    insert into system.sach@CHS1_DBLINK(masach, tensach, giaban)
    values(in_masach, in_tensach, in_giaban);
    ---them vao site 2
    insert into system.sach@CHS2_DBLINK(masach, tensach, giaban)
    values(in_masach, in_tensach, in_giaban);
    ---
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
    ---sua tai site chu
    update system.sach
    set tensach=in_tensach, giaban=in_giaban
    where masach=in_masach;
    ---sua tai site 1
    update system.sach@CHS1_DBLINK
    set tensach=in_tensach, giaban=in_giaban
    where masach=in_masach;
    ---sua tai site 2
    update system.sach@CHS2_DBLINK
    set tensach=in_tensach, giaban=in_giaban
    where masach=in_masach;
    ---
    commit;
    exception
        when others then
        rollback;
end;
---HOADON
---ham tao ma hoadon danh cho site cuc bo
/*create or replace function f_tao_ma_hd(
    in_mach IN varchar2
)
return varchar2
is 
    v_count number;
    v_dem_hd number; 
    v_mahd varchar2(255);
begin    
    select count(*) into v_count from system.hoadon;
    v_dem_mahd:=v_count+1;
    v_mahd:=v_mach||'HD'||to_char(v_dem_mahd);
return v_mahd;
end;
/
select system.f_tao_ma_hd() from dual;
*/
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
    select * from system.hoadon
    where mahd=in_mahd or makh=in_makh;
end;
/
---thu tuc xoa hoa don va cac cthd cua hoa don do
create or replace procedure p_xoa_hoadon(
    in_mahd IN varchar2
)
is
    v_mach varchar2(255);
begin
    ---lay ma cua hang tu hoa don can xoa
    select mach into v_mach
    from system.hoadon
    where mahd=in_mahd;
    ---xoa tai site chu
    delete from system.cthd
    where mahd=in_mahd;
    delete from system.hoadon
    where mahd=in_mahd;
    ---kiem tra hoa don do thuoc cua hang thi se xoa o cua hang do
    ---xoa tai site 1
    if v_mach='CH01' then    
        delete from system.cthd@CHS1_DBLINK
        where mahd=in_mahd;
        delete from system.hoadon@CHS1_DBLINK
        where mahd=in_mahd;
    ---xoa tai site 2
    elsif v_mach='CH02' then
        delete from system.cthd@CHS2_DBLINK
        where mahd=in_mahd;
        delete from system.hoadon@CHS2_DBLINK
        where mahd=in_mahd;
    end if;
    ---commit
    commit;
    exception
        when others then
        rollback;
end;
/
/*---thu tuc them hoa don
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
*/
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
    from system.cthd c, system.sach s
    where mahd=in_mahd and c.masach=s.tensach;
end;
/
/*---thu tuc them chi tiet hoa don
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
*/
/*---thu tuc xoa cthd va cap nhat lai so luong sach
create or replace procedure p_xoa_cthd(
    in_mahd IN varchar2,
    in_masach IN varchar2,
    in_slgban IN int
)
is
    v_mach varchar2(255);
begin
    ---kiem tra cthd do thuoc hoadon cua cua hang nao
    select mach into v_mach
    from system.hoadon
    where mahd=in_mahd;
    ---xoa tai site chu 
    delete from system.cthd
    where mahd=in_mahd and masach=in_masach;
    ---
    update system.ctch
    set slg_ton=slg_ton+in_slgban
    where mach=v_mach and masach=in_masach;
    ---xoa va cap nhat tai site 1
    if v_mach='CH01' then
        delete from system.cthd@CHS1_DBLINK
        where mahd = in_mahd and masach=in_masach;
        ---
        update system.ctch@CHS1_DBLINK
        set slg_ton=slg_ton+in_slgban
        where mach=v_mach and masach=in_masach;
    ---xoa va cap nhat tai site 2
    elsif v_mach='CH02' then
        delete from system.cthd@CHS2_DBLINK
        where mahd = in_mahd and masach=in_masach;
        ---
        update system.ctch@CHS2_DBLINK
        set slg_ton=slg_ton+in_slgban
        where mach=v_mach and masach=in_masach;
    end if;
    ---commit
    commit;
        exception
        when others then
        rollback;
end;
*/
---thu tuc xoa khachhang vao hoadon cua khachhang do
---khong xoa hoa don , chi xoa khach hang
---cap nhat makh thanh NULL va xoa khachhang
create or replace procedure p_xoa_khachhang(
    in_makh IN varchar2
)
is
    v_count number:=0;
begin
    select count(*) into v_count from system.hoadon where makh=in_makh;
    if(v_count=0) then
        ---xoa o site chu
        delete from system.khachhang where makh=in_makh;
        ---xoa o site 1
        delete from system.khachhang@CHS1_DBLINK where makh=in_makh;
        ---xoa o site 2
        delete from system.khachhang@CHS2_DBLINK where makh=in_makh;
    else
        ---cap nhat makh thanh NULL va xoa
        update system.hoadon
        set makh='NULL'
        where makh=in_makh;
        delete from system.khachhang where makh=in_makh;
        ---cap nhat va xoa tai site 1
        update system.hoadon@CHS1_DBLINK
        set makh='NULL'
        where makh=in_makh;
        delete from system.khachhang@CHS1_DBLINK where makh=in_makh;
        ---cap nhat va xoa tai site 2
        update system.hoadon@CHS2_DBLINK
        set makh='NULL'
        where makh=in_makh;
        delete from system.khachhang@CHS2_DBLINK where makh=in_makh;
    end if;
    commit;
    exception
        when others then
        rollback;
end;
/
create or replace function f_ten_kh(in_makh in varchar2)
return nvarchar2
is
    v_tenkh nvarchar2(255);    
begin
    select tenkh into v_tenkh
    from system.khachhang
    where makh=in_makh;
    
    return v_tenkh;
end;
/
create or replace procedure p_xoa_hoa_don(
    in_mahd in varchar2
) 
is 
    v_exist varchar2(255):=null;
    v_count int:=0;
    v_mach varchar2(255);
    v_masach varchar2(255);
    v_slg_ban int;
begin
    ---kiem tra ton tai cua hoa don can xoa
    select mahd into v_exists from system.hoadon where mahd=in_mahd;
    select count(*) into v_count from system.cthd where mahd=in_mahd;
    select mach into v_mach from system.cuahang;
    ---kiem tra ton tai mahd va thuc hien xoa
    if v_exists is not null then
        while v_count>0
        loop
            select masach, slg_ban into v_masach, v_slg_ban
            from system.cthd
            where rownum=1 and mahd=in_mahd;
            ---xoa tai site cuc bo
            delete from system.cthd
            where mahd=in_mahd and masach=v_masach;
            ---cap nhat tai site cuc bo
            update system.ctch
            set slg_ton=slg_ton+v_slg_ban
            where masach=v_masach;
            ---xoa tai site chu
            delete from system.cthd@CHS_DBLINK
            where mahd=in_mahd and masach=v_masach;
            ---cap nhat tai site chu
            update system.ctch@CHS_DBLINK
            set slg_ton=slg_ton+v_slg_ban
            where masach=v_masach and mach=v_mach;
            v_count:=v_count-1;
        end loop;
        ---xoa hoa don sau khi da xoa xong cthd
        if v_count =0 then
            ---xoa tao site cuc bo
            delete from system.hoadon
            where mahd=in_mahd;
            ---xoa tai site chu
            delete from system.hoadon@CHS_DBLINK
            where mahd=in_mahd;
        end if;
    end if;
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
--- thu tuc tu dong cap nhat du lieu
---cap nhat bang khach hang
---cap nhat tai site 1
create or replace procedure cap_nhat_khach_hang_1
is
begin
    ---them neu khach hang do chua co tai he thong
    insert into system.khachhang(makh, tenkh, sdt, diachi)
    select makh, tenkh, sdt, diachi
    from system.khachhang@CHS1_DBLINK site1
    where not exists (
        select *
        from system.khachhang site0
        where site0.makh=site1.makh);
    ---cap nhat neu khach hang da ton tai
    update system.khachhang site0
    set tenkh=(
        select tenkh 
        from system.khachhang@CHS1_DBLINK site1
        where site1.makh=site0.makh),
        sdt=(
        select sdt 
        from system.khachhang@CHS1_DBLINK site1
        where site1.makh=site0.makh),
        diachi=(
        select diachi 
        from system.khachhang@CHS1_DBLINK site1
        where site1.makh=site0.makh)
    where not exists(
        select *
        from system.khachhang site0
        where site1.makh=site0.makh 
                and site1.tenkh=site0.tenkh
                and site1.sdt=site0.sdt
                and site1.diachi=site0.diachi);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
---cap nhat tai site 2
create or replace procedure cap_nhat_khach_hang_2
is
begin
     ---them neu khach hang do chua co tai he thong
    insert into system.khachhang(makh, tenkh, sdt, diachi)
    select makh, tenkh, sdt, diachi
    from system.khachhang@CHS2_DBLINK site2
    where not exists (
        select *
        from system.khachhang site0
        where site0.makh=site2.makh);
    ---cap nhat neu khach hang da ton tai
    update system.khachhang site0
    set tenkh=(
        select tenkh 
        from system.khachhang@CHS2_DBLINK site2
        where site0.makh=site2.makh),
        sdt=(
        select sdt 
        from system.khachhang@CHS1_DBLINK site2
        where site0.makh=site2.makh),
        diachi=(
        select diachi 
        from system.khachhang@CHS1_DBLINK site2
        where site0.makh=site2.makh)
    where not exists(
        select *
        from system.khachhang site0
        where site0.makh=site2.makh 
                and site0.tenkh=site2.tenkh
                and site0.sdt=site2.sdt
                and site0.diachi=site2.diachi);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
---
create or replace procedure cap_nhat_khach_hang
is
begin
    ---cap nhat tu site 1
    system.cap_nhat_khach_hang_1;
    ---cap nhat tu site 2
    system.cap_nhat_khach_hang_2;
end;
/
--- cap nhat sach
create or replace procedure cap_nhat_sach
is
begin
    ---cap nhat tu site 1
    insert into system.sach(masach, tensach, giaban)
    select masach, tensach, giaban
    from system.sach@CHS1_DBLINK site1
    where not exists (
        select 1
        from system.sach site0
        where site0.masach=site1.masach);
    ---cap nhat tu site 2
    insert into system.sach(masach, tensach, giaban)
    select masach, tensach, giaban
    from system.sach@CHS2_DBLINK site2
    where not exists (
        select 1
        from system.sach site0
        where site0.masach=site2.masach);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
---cap nhat chi tiet cua hang
create or replace procedure cap_nhat_cua_hang
is
begin
    ---cap nhat tu site 1
    ---them
    insert into system.ctch(mach, masach, slg_ton)
    select mach, masach, slg_ton
    from system.ctch@CHS1_DBLINK site1
    where not exists (
        select 1
        from system.ctch site0
        where site0.masach=site1.masach and site0.mach=site1.mach);
    ---cap nhat
    update system.ctch site0
    set slg_ton=(
        select slg_ton 
        from system.ctch@CHS1_DBLINK site1
        where site0.masach=site1.masach and site0.mach=site1.mach)
    where exists (
        select 1
        from system.CHS1_DBLINK site1
        where site0.masach=site1.masach and site0.mach=site1.mach);
    ---cap nhat tu site 2
    insert into system.ctch(mach, masach, slg_ton)
    select mach, masach, slg_ton
    from system.ctch@CHS2_DBLINK site2
    where not exists (
        select 1
        from system.ctch site0
        where site0.masach=site2.masach and site0.mach=site2.mach);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
---cap nhat hoa don va chi tiet hoa don
create or replace procedure cap_nhat_hoa_don
is
begin
    ---cap nhat tu site 1
    insert into system.hoadon(mahd, makh, mach, ngaylap, tongtien)
    select mahd, makh, mach, ngaylap, tongtien
    from system.hoadon@CHS1_DBLINK site1
    where not exists (
        select 1
        from system.hoadon site0
        where site0.mahd=site1.mahd);
    insert into system.cthd(mahd, masach, slg_ban)
    select mahd, masach, slg_ban
    from system.cthd@CHS1_DBLINK site1
    where not exists(
        select 1
        from system.cthd
        where site0.mahd=site1.mahd and site0.masach=site1.masach);
    ---cap nhat tu site 2
    insert into system.hoadon(mahd, makh, mach, ngaylap, tongtien)
    select mahd, makh, mach, ngaylap, tongtien
    from system.hoadon@CHS2_DBLINK site2
    where not exists (
        select 1
        from system.hoadon site0
        where site0.mahd=site2.mahd);
    insert into system.cthd(mahd, masach, slg_ban)
    select mahd, masach, slg_ban
    from system.cthd@CHS2_DBLINK site2
    where not exists(
        select 1
        from system.cthd
        where site0.mahd=site2.mahd and site0.masach=site2.masach);
    ---
    commit;
    exception
        when others then
        rollback;
end;
/
--====================================================================
---quan ly tai nguyen sga
create or replace procedure p_xem_tai_nguyen(
    cur_tai_nguyen OUT sys_refcursor)
is
begin
    open cur_tai_nguyen for
        select name, value
        from v$sga;
end;
/
---quan ly session
create or replace procedure p_xem_session(
    cur_session OUT sys_refcursor,
    cua_hang IN varchar2)
is
begin
    if cua_hang='CH01' then
        open cur_session for
            select sid, serial#, username, program 
            from v$session@CHS1_DBLINK 
            where type!='BACKGROUND'; 
    elsif cua_hang='CH02' then
        open cur_session for
            select sid, serial#, username, program 
            from v$session@CHS2_DBLINK 
            where type!='BACKGROUND';
    else
        open cur_session for
            select sid, serial#, username, program 
            from v$session@CHS1_DBLINK 
            where type!='BACKGROUND'
            union
            select sid, serial#, username, program 
            from v$session@CHS2_DBLINK 
            where type!='BACKGROUND';
    end if;       
end;
/
-----tao job backup
SELECT * FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME = 'BACK_UP_JOB';
select * from all_scheduler_jobs where job_name='BACK_UP_JOB';
SELECT * FROM ALL_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'BACK_UP_JOB';
/
---program
begin
    dbms_scheduler.create_program(
        program_name=>'RUN_BACK_UP',
        program_type=>'EXECUTABLE',
        program_action=>'cmd.exe D:\app\tuann\scripts\backup.cmd',
        enabled=>true
    );
end;
/
begin 
    dbms_scheduler.drop_program(
        program_name=>'RUN_BACK_UP',
        force=> FALSE
    );
end;
/
---job
begin
    dbms_scheduler.create_job(
        job_name=>'BACK_UP_JOB',
        program_name=>'RUN_BACK_UP',         
        repeat_interval=>'FREQ=MINUTELY;INTERVAL=3',
        enabled=>true
    );
end;
/
BEGIN
    dbms_scheduler.run_job(job_name =>'BACK_UP_JOB');
END;
/
begin 
    dbms_scheduler.drop_job(
        job_name=>'BACK_UP_JOB',
        force=> FALSE
    );    
end;
/
---delete from all_scheduler_job_run_details WHERE JOB_NAME = 'BACK_UP_JOB';