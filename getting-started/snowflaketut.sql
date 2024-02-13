create or replace database sf_tuts;

select current_database(), current_schema();

create or replace table emp_basic(
    first_name STRING ,
    last_name STRING ,
    email STRING ,
    streetaddress STRING ,
    city STRING ,
    start_date DATE
);

/*Creación de Warehouse */
create or replace warehouse sf_tuts_wh with
    warehouse_size = 'X-SMALL'
    AUTO_SUSPEND = 180
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

--Se selecciona nuestra warehouse recién creada
SELECT CURRENT_WAREHOUSE();

--El comando PUT se encarga de comprimir archivos usando gzip
PUT file://C:\Users\Lenovo\Documents\VSCode\snowflake\getting-started\employees0*.csv @sf_tuts.public.%emp_basic;

--listado de los archivos
list @sf_tuts.public.%emp_basic;

--copiamos los datos a las tablas destino
copy into emp_basic
    from @%emp_basic
    file_format = (type = csv field_optionally_enclosed_by='"')
    pattern = '.*employees0[1-5].csv.gz'
    on_error = 'skip_file';

--hacemos un select a los datos que cargamos
select * from emp_basic;