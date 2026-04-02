create table job_applied (
    job_id int,
    application_sent_date date,
    custom_resume boolean,
    resume_file_name varchar(255),
    cover_letter_sent boolean,
    cover_letter_file_name varchar(255),
    status varchar(50)
);

select *
from job_applied

insert into job_applied
    (job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status)
values
    (1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'),
    (2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    false,
    null,
    'interview scheduled'),
    (3,
    '2024-02-03',
    true,
    'resume_03.pdf',
    true,
    'cover_letter_03.pdf',
    'ghosted'),
    (4,
    '2024-02-04',
    true,
    'resume_04.pdf',
    false,
    Null,
    'submitted'),
    (5,
    '2024-02-05',
    false,
    'resume_05.pdf',
    true,
    'cover_letter_05.pdf',
    'rejected');




alter table job_applied
add contact varchar(50);

update job_applied
set contact = 'Erlich Bachman'
where job_id = 1;

update job_applied
set contact = 'Dinesh Chugtai'
where job_id = 2;

update job_applied
set contact = 'Bertram Gilfoyle'
where job_id = 3;

update job_applied
set contact = 'Jian Yang'
where job_id = 4;

update job_applied
set contact = 'Big Head'
where job_id = 5;

alter table job_applied
rename column contact to contact_name;

alter table job_applied
alter column contact_name type text;

alter table job_applied
drop column contact_name;

