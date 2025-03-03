-- 每個工具的角色與如何互相協作
-- Docker：
-- 使用 Docker 來容器化 PostgreSQL 資料庫，是為了確保每個開發者的開發環境一致，不管是本地還是 CI/CD 環境。這樣可以避免因為不同的操作系統或軟體版本造成的環境差異問題，確保每個開發者都可以在一個相同的環境中執行 PostgreSQL。例如，開發者可以快速啟動一個包含 PostgreSQL 的容器，並在其中進行資料庫的開發和測試。
-- DBeaver：
-- DBeaver 是一個 SQL 客戶端工具，可以用來直接操控 PostgreSQL 資料庫。開發者可以透過 DBeaver 來寫 SQL 查詢、管理資料庫結構、查看資料等。它與 Docker 運行的 PostgreSQL 容器相連接，讓開發者可以在本地環境中輕鬆管理資料庫。
-- GitHub Actions：
-- GitHub Actions 是一個 CI/CD 工具，可以讓你在每次 push 代碼至 Git 儲存庫時自動執行指定的腳本。這可以用來執行測試、建構、部署等流程。在你的情境中，GitHub Actions 主要是用來在每次 push 代碼時執行自動化流程，例如跑單元測試、檢查程式碼風格等，這樣可以確保代碼的品質，並且在推送代碼之前發現問題。

-- 組合的效果：
-- DBeaver + PostgreSQL (Docker)：
-- 在開發過程中，開發者可以使用 DBeaver 來操作運行在 Docker 容器中的 PostgreSQL 資料庫，確保資料庫操作和 SQL 查詢的正確性。這樣開發者能夠在本地進行資料庫測試，確保資料庫邏輯不會出錯。

-- GitHub Actions + Docker：
-- 當開發者將代碼推送至 Git 儲存庫時，GitHub Actions 可以自動執行測試和部署流程，並且在 CI/CD 環境中運行 Docker 容器，這樣可以模擬真實環境並執行測試，避免環境差異造成的問題。

-- GitHub Actions + DBeaver：
-- 雖然 GitHub Actions 主要用來執行代碼測試和建構，但在某些情況下，你可能會希望把資料庫的測試整合進去，這時候可以使用 GitHub Actions 來執行資料庫的 migration 或是測試資料庫連接等操作，然後再用 DBeaver 驗證結果。

-- 總結來說，這些工具組合起來，能夠確保開發環境的一致性、資料庫操作的正確性，並且提供自動化測試和版本控制，讓開發過程更加順利。

------------------------------------------------------------

-- 練習流程
-- 1. 在 DBeaver 撰寫 SQL
-- 2. 回到 VSCode，把 SQL 存到 migration 檔案
-- 3. Git Push（更新專案）
-- 4. 在 DBeaver 點 Refresh，確保看到最新變更

------------------------------------------------------------

-- ████████  █████   █     █ 
--   █ █   ██    █  █     ██ 
--   █ █████ ███ ███       █ 
--   █ █   █    ██  █      █ 
--   █ █   █████ █   █     █ 
-- ===================== ====================
-- 1. 用戶資料，資料表為 USER

-- 1. 新增：新增六筆用戶資料，資料如下：
--     1. 用戶名稱為`李燕容`，Email 為`lee2000@hexschooltest.io`，Role為`USER`
--     2. 用戶名稱為`王小明`，Email 為`wXlTq@hexschooltest.io`，Role為`USER`
--     3. 用戶名稱為`肌肉棒子`，Email 為`muscle@hexschooltest.io`，Role為`USER`
--     4. 用戶名稱為`好野人`，Email 為`richman@hexschooltest.io`，Role為`USER`
--     5. 用戶名稱為`Q太郎`，Email 為`starplatinum@hexschooltest.io`，Role為`USER`
--     6. 用戶名稱為 透明人，Email 為 opacity0@hexschooltest.io，Role 為 USER
insert into "USER" (name, email, "role") values
('李燕容', 'lee2000@hexschooltest.io', 'USER'),
('王小明', 'wXlTq@hexschooltest.io', 'USER'),
('肌肉棒子', 'muscle@hexschooltest.io', 'USER'),
('好野人', 'richman@hexschooltest.io', 'USER'),
('Q太郎', 'starplatinum@hexschooltest.io', 'USER'),
('透明人', 'opacity0@hexschooltest.io', 'USER');

-- 1-2 修改：用 Email 找到 李燕容、肌肉棒子、Q太郎，如果他的 Role 為 USER 將他的 Role 改為 COACH
update "USER"
set "role" = 'COACH'
where email in (
  'lee2000@hexschooltest.io',
  'muscle@hexschooltest.io',
  'starplatinum@hexschooltest.io'
)
and "role" = 'USER';

-- 1-3 刪除：刪除USER 資料表中，用 Email 找到透明人，並刪除該筆資料
delete from "USER"
where email = 'opacity0@hexschooltest.io';

-- 1-4 查詢：取得USER 資料表目前所有用戶數量（提示：使用count函式）
select
  count(*) as 所有用戶數量
from "USER";

-- 1-5 查詢：取得 USER 資料表所有用戶資料，並列出前 3 筆（提示：使用limit語法）
select * from "USER" limit 3;


------------------------------------------------------------

--  ████████  █████   █    ████  
--    █ █   ██    █  █         █ 
--    █ █████ ███ ███       ███  
--    █ █   █    ██  █     █     
--    █ █   █████ █   █    █████ 
-- ===================== ====================
-- 2. 組合包方案 CREDIT_PACKAGE、客戶購買課程堂數 CREDIT_PURCHASE
-- 2-1. 新增：在`CREDIT_PACKAGE` 資料表新增三筆資料，資料需求如下：
    -- 1. 名稱為 `7 堂組合包方案`，價格為`1,400` 元，堂數為`7`
    -- 2. 名稱為`14 堂組合包方案`，價格為`2,520` 元，堂數為`14`
    -- 3. 名稱為 `21 堂組合包方案`，價格為`4,800` 元，堂數為`21`
insert into "CREDIT_PACKAGE" (name, credit_amount, price) values
('7 堂組合包方案', 7, 1400),
('14 堂組合包方案', 14, 2520),
('21 堂組合包方案', 21, 4800);
-- 2-2. 新增：在 `CREDIT_PURCHASE` 資料表，新增三筆資料：（請使用 name 欄位做子查詢）
    -- 1. `王小明` 購買 `14 堂組合包方案`
    -- 2. `王小明` 購買 `21 堂組合包方案`
    -- 3. `好野人` 購買 `14 堂組合包方案`
insert into "CREDIT_PURCHASE" (user_id ,credit_package_id, purchased_credits, price_paid) values 
(
  (select id from "USER" where name = '王小明'),
  (select id from "CREDIT_PACKAGE" where name = '14 堂組合包方案'),
  (select credit_amount from "CREDIT_PACKAGE" where name = '14 堂組合包方案'),
  (select price from "CREDIT_PACKAGE" where name = '14 堂組合包方案')
),
(
  (select id from "USER" where name = '王小明'),
  (select id from "CREDIT_PACKAGE" where name = '21 堂組合包方案'),
  (select credit_amount from "CREDIT_PACKAGE" where name = '21 堂組合包方案'),
  (select price from "CREDIT_PACKAGE" where name = '21 堂組合包方案')
),
(
  (select id from "USER" where name = '好野人'),
  (select id from "CREDIT_PACKAGE" where name = '14 堂組合包方案'),
  (select credit_amount from "CREDIT_PACKAGE" where name = '14 堂組合包方案'),
  (select price from "CREDIT_PACKAGE" where name = '14 堂組合包方案')
);


------------------------------------------------------------

-- ████████  █████   █    ████   
--   █ █   ██    █  █         ██ 
--   █ █████ ███ ███       ███   
--   █ █   █    ██  █         ██ 
--   █ █   █████ █   █    ████   
-- ===================== ====================
-- 3. 教練資料 ，資料表為 COACH ,SKILL,COACH_LINK_SKILL
-- 3-1 新增：在`COACH`資料表新增三筆教練資料，資料需求如下：
    -- 1. 將用戶`李燕容`新增為教練，並且年資設定為2年（提示：使用`李燕容`的email ，取得 `李燕容` 的 `id` ）
    -- 2. 將用戶`肌肉棒子`新增為教練，並且年資設定為2年
    -- 3. 將用戶`Q太郎`新增為教練，並且年資設定為2年
insert into "COACH" (user_id, experience_years) values
((select id from "USER" where email = 'lee2000@hexschooltest.io'), 2),
((select id from "USER" where email = 'muscle@hexschooltest.io'), 2),
((select id from "USER" where email = 'starplatinum@hexschooltest.io'), 2);

-- 顯示結果 =====================
-- select
--   "COACH".id as 編號,
--   "USER".name as 姓名,
--   "COACH".experience_years
-- from "COACH"
-- inner join "USER" on "COACH".user_id = "USER".id;

-- 3-2. 新增：承1，為三名教練新增專長資料至 `COACH_LINK_SKILL` ，資料需求如下：
    -- 1. 所有教練都有 `重訓` 專長
    -- 2. 教練`肌肉棒子` 需要有 `瑜伽` 專長
    -- 3. 教練`Q太郎` 需要有 `有氧運動` 與 `復健訓練` 專長
-- 資料整理 =====================
    -- lee2000@hexschooltest.io 重訓
    -- muscle@hexschooltest.io 重訓、瑜伽
    -- starplatinum@hexschooltest.io 重訓、有氧運動、復健訓練`
-- A. 先嘗試寫一個教練、一個專長
insert into "COACH_LINK_SKILL" (coach_id, skill_id) values 
(
  (select id from "COACH" where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io')),
  (select id from "SKILL" where name = '重訓')
);

-- 顯示結果 =====================
-- 1. 一個教練有多個專長，會產生多行資料，每一行對應一個專長。
-- select 
--   "USER".name as 教練姓名,
--   "SKILL".name as 專長
-- from "COACH_LINK_SKILL"
-- inner join "SKILL" on "COACH_LINK_SKILL".skill_id = "SKILL".id
-- inner join "COACH" on "COACH_LINK_SKILL".coach_id = "COACH".id
-- inner join "USER" on "COACH".user_id = "USER".id;
-- 2. STRING_AGG(欄位名稱, '分隔符號') 可以將多行資料合併成一行，並用分隔符號分隔。
-- STRING_AGG() 中的 AGG 是 Aggregate（聚合） 的縮寫，表示這是一個聚合函數，聚合函數用來對多行資料執行計算，然後回傳一個單一的結果。例如：SUM()、COUNT()、AVG()、MAX()、MIN()、STRING_AGG()
-- 🎯 STRING_AGG()：會將「多行」的資料合併成一個字串，與 SUM() 把多個數值相加類似。
-- select 
--   "USER".name as 教練姓名,
--   STRING_AGG("SKILL".name, ', ') as 專長
-- from "COACH_LINK_SKILL"
-- inner join "SKILL" on "COACH_LINK_SKILL".skill_id = "SKILL".id
-- inner join "COACH" on "COACH_LINK_SKILL".coach_id = "COACH".id
-- inner join "USER" on "COACH".user_id = "USER".id
-- group by "USER".name;

-- B. 嘗試寫一個教練、多個專長
-- insert into "COACH_LINK_SKILL" (coach_id, skill_id) values
-- (
--   (select id from "COACH" where user_id = (select id from "USER" where email = 'muscle@hexschooltest.io')),
--   (select id from "SKILL" where name in ('重訓', '瑜伽'))
-- );
-- ❌ 錯誤原因 → IN 返回多個值，而 INSERT INTO "COACH_LINK_SKILL" 期望的是單一 skill_id。
-- ✅ 解決方案 → 將每個專長 skill_id 分開插入，用 INSERT ... SELECT 批量插入：
insert into "COACH_LINK_SKILL" (coach_id, skill_id)
-- 先把欄位都選起來，再一起插入
select
  -- 只會回傳單一 coach_id
  (select id from "COACH" where user_id = (select id from "USER" where email = 'muscle@hexschooltest.io')),
  -- 會回傳多個 skill_id
  id
from "SKILL"
where name in ('重訓', '瑜伽');

-- 顯示結果 =====================
-- 1. 顯示多行資料
-- select 
--    "USER".name as 教練姓名,
--    "SKILL".name as 專長
-- from "COACH_LINK_SKILL"
-- inner join "SKILL" on "COACH_LINK_SKILL".skill_id = "SKILL".id
-- inner join "COACH" on "COACH_LINK_SKILL".coach_id = "COACH".id
-- inner join "USER" on "COACH".user_id = "USER".id
-- group by "USER".name, "SKILL".name;
-- 2. 顯示 STRING_AGG
-- select 
--    "USER".name as 教練姓名,
--    string_agg("SKILL".name, ', ') as 專長
-- from "COACH_LINK_SKILL"
-- inner join "SKILL" on "COACH_LINK_SKILL".skill_id = "SKILL".id
-- inner join "COACH" on "COACH_LINK_SKILL".coach_id = "COACH".id
-- inner join "USER" on "COACH".user_id = "USER".id
-- group by "USER".name;

-- C. 一個教練、多個專長
insert into "COACH_LINK_SKILL" (coach_id, skill_id)
-- 先把欄位都選起來，再一起插入
select
  (select id from "COACH" where user_id = (select id from "USER" where email = 'starplatinum@hexschooltest.io')),
  id
from "SKILL" where name in ('重訓', '有氧運動', '復健訓練');

-- 顯示結果 =====================
-- select 
--   "USER".name as 教練姓名,
--   string_agg("SKILL".name, ', ') as 專長
-- from "COACH_LINK_SKILL"
-- inner join "SKILL" on "COACH_LINK_SKILL".skill_id = "SKILL".id
-- inner join "COACH" on "COACH_LINK_SKILL".coach_id = "COACH".id
-- inner join "USER" on "COACH".user_id = "USER".id
-- group by "USER".name;

-- 3-3 修改：更新教練的經驗年數，資料需求如下：
    -- 1. 教練`肌肉棒子` 的經驗年數為3年
    -- 2. 教練`Q太郎` 的經驗年數為5年
update "COACH"
set experience_years = 3
where user_id = (select id from "USER" where email = 'muscle@hexschooltest.io');

update "COACH"
set experience_years = 5
where user_id = (select id from "USER" where email = 'starplatinum@hexschooltest.io');

-- 顯示結果 =====================
-- select
--   "USER".name as 教練姓名,
--   "COACH".experience_years as 年資
-- from "COACH"
-- inner join "USER" on "COACH".user_id = "USER".id;

-- 進階寫法 =====================
-- 使用 CASE 表達式來進行批量更新，CASE 表達式在 SQL 中的作用和 JavaScript 中的 if...else 邏輯非常相似。
-- update "COACH"
-- set experience_years =
--   case -- CASE 相當於 if，根據 USER.email 的不同值來設置不同的 experience_years
--     when "USER".email = 'muscle@hexschooltest.io' than 3 -- WHEN 相當於 else if，THEN 相當於條件為 true 時的結果
--     when "USER".email = 'starplatinum@hexschooltest.io' than 5
--     else experience_years -- ELSE 則相當於 else，提供當所有條件都不成立時的默認值
--   end
-- from "USER" -- FROM "USER" 連接 USER 表，並根據 COACH.user_id 和 USER.id 進行條件過濾
-- where "COACH".user_id = "USER".id;

-- 3-4 刪除：新增一個專長 空中瑜伽 至 SKILL 資料表，之後刪除此專長。
insert into "SKILL" (name) values ('空中瑜伽');

delete from "SKILL"
where name = '空中瑜伽';


------------------------------------------------------------

--  ████████  █████   █    █   █ 
--    █ █   ██    █  █     █   █ 
--    █ █████ ███ ███      █████ 
--    █ █   █    ██  █         █ 
--    █ █   █████ █   █        █ 
-- ===================== ==================== 
-- 4. 課程管理 COURSE 、組合包方案 CREDIT_PACKAGE

-- 4-1. 新增：在`COURSE` 新增一門課程，資料需求如下：
    -- 1. 教練設定為用戶`李燕容` 
    -- 2. 在課程專長 `skill_id` 上設定為「 `重訓` 」
    -- 3. 在課程名稱上，設定為「`重訓基礎課`」
    -- 4. 授課開始時間`start_at`設定為2024-11-25 14:00:00
    -- 5. 授課結束時間`end_at`設定為2024-11-25 16:00:00
    -- 6. 最大授課人數`max_participants` 設定為10
    -- 7. 授課連結設定`meeting_url`為 https://test-meeting.test.io
insert into "COURSE" (user_id, skill_id, name, start_at, end_at, max_participants, meeting_url)
values
(
  (select id from "USER" where email = 'lee2000@hexschooltest.io'),
  (select id from "SKILL" where name = '重訓'),
  '重訓基礎課',
  -- PostgreSQL 會自動將 '2024-11-25 14:00:00' 轉換為 timestamp 類型
  '2024-11-25 14:00:00',
  '2024-11-25 16:00:00',
  10,
  'https://test-meeting.test.io'
);

-- 顯示結果 =====================
-- select 
--   "USER".name as 教練姓名,
--   "SKILL".name as 教練專長,
--   "COURSE".name as 課程名稱,
--   "COURSE".start_at as 開始時間,
--   "COURSE".end_at as 結束時間,
--   "COURSE".max_participants as 人數限制,
--   "COURSE".meeting_url as 授課連結
-- from "COURSE"
-- inner join "USER" on "COURSE".user_id = "USER".id
-- inner join "SKILL" on "COURSE".skill_id = "SKILL".id;


------------------------------------------------------------

-- ████████  █████   █    █████ 
--   █ █   ██    █  █     █     
--   █ █████ ███ ███      ████  
--   █ █   █    ██  █         █ 
--   █ █   █████ █   █    ████  
-- ===================== ====================

-- 5. 客戶預約與授課 COURSE_BOOKING
-- 5-1. 新增：請在 `COURSE_BOOKING` 新增兩筆資料：
    -- 1. 第一筆：`王小明`預約 `李燕容` 的課程
        -- 1. 預約人設為`王小明`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課
    -- 2. 新增： `好野人` 預約 `李燕容` 的課程
        -- 1. 預約人設為 `好野人`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課
-- 資料整理 =====================
        -- `李燕容`，Email 為`lee2000@hexschooltest.io`
        -- `王小明`，Email 為`wXlTq@hexschooltest.io`
        -- `好野人`，Email 為`richman@hexschooltest.io`
-- 🎯 李燕容可能有多門課
-- 情境 1️⃣：確認李燕容有開重訓基礎課
-- 👉 李燕容的課程 and name = '重訓基礎課' limit 1
-- and 確保李燕容有開這門課，如果沒有，則不會插入資料。
-- 加上 limit 1：避免 course_id 查詢到多筆資料，確保只取得一筆課程 ID，避免 SQL 執行錯誤。
insert into "COURSE_BOOKING" (user_id, course_id, booking_at, status)
values
(
  (select id from "USER" where email = 'wXlTq@hexschooltest.io'),
  (select id from "COURSE" where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io') and name = '重訓基礎課' limit 1),
  '2024-11-24 16:00:00',
  '即將授課'
),
(
  (select id from "USER" where email = 'richman@hexschooltest.io'),
  (select id from "COURSE" where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io') and name = '重訓基礎課' limit 1),
  '2024-11-24 16:00:00',
  '即將授課'
);
-- 🛑 潛在問題：如果李燕容沒有開重訓基礎課，INSERT 會插入 NULL，導致錯誤！解決方案：可以在執行 INSERT 之前先查詢，確認 course_id 存在。

-- 情境 2️⃣：不確認李燕容是否有開重訓基礎課
-- 👉 最安全的方法是：先檢查 course_id 是否存在。如果 course_id 不存在，則不執行 INSERT。
-- INSERT ... SELECT 避免 NULL：如果 COURSE 沒有找到重訓基礎課，就不會執行 INSERT，避免 NULL 錯誤！
-- 只執行一次 SELECT：更有效率，不像 VALUES (...) 那樣要執行兩次 SELECT。
-- 確保 course_id 存在：只有在重訓基礎課存在時，才會插入資料，不會發生 NULL 錯誤。
-- insert into "COURSE_BOOKING" (user_id, course_id, booking_at, status)
-- select
--   (select id from "USER" where email = 'wXlTq@hexschooltest.io'),
--   id,
--   '2024-11-24 16:00:00',
--   '即將授課'
-- from "COURSE"
-- where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io')
-- and name = '重訓基礎課'
-- limit 1;

-- 顯示結果 =====================
-- select
--   "USER".name as 客戶姓名,
--   "COURSE".name as 課程名稱,
--   booking_at as 預約時間,
--   status as 課程狀態
-- from "COURSE_BOOKING"
-- inner join "USER" on "COURSE_BOOKING".user_id = "USER".id
-- inner join "COURSE" on "COURSE_BOOKING".course_id = "COURSE".id;


-- 5-2. 修改：`王小明`取消預約 `李燕容` 的課程，請在`COURSE_BOOKING`更新該筆預約資料：
    -- 1. 取消預約時間`cancelled_at` 設為2024-11-24 17:00:00
    -- 2. 狀態`status` 設定為課程已取消
-- 🎯 如果王小明預約了多門課程，但 WHERE 條件只篩選了 user_id，會導致所有王小明預約的課程都被取消。如果只想取消李燕容的課程，應該再加一個條件，確保是李燕容的課程
-- 👉 王小明預約的課程 && 李燕容開的課
update "COURSE_BOOKING"
set
  cancelled_at = '2024-11-24 17:00:00',
  status = '課程已取消'
where user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
and course_id = (select id from "COURSE" where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io'));

-- 5-3. 新增：`王小明`再次預約 `李燕容` 的課程，請在`COURSE_BOOKING`新增一筆資料：
    -- 1. 預約人設為`王小明`
    -- 2. 預約時間`booking_at` 設為2024-11-24 17:10:25
    -- 3. 狀態`status` 設定為即將授課
insert into "COURSE_BOOKING" (user_id, course_id, booking_at, status)
select
  (select id from "USER" where email = 'wXlTq@hexschooltest.io'),
  id,
  '2024-11-24 17:10:25',
  '即將授課'
from "COURSE"
where user_id = (select id from "USER" where email = 'lee2000@hexschooltest.io')
and name = '重訓基礎課'
limit 1;
-- 顯示結果 =====================
-- select
--   "USER".name as 客戶姓名,
--   "COURSE".name as 課程名稱,
--   booking_at as 預約時間,
--   status as 預約狀態
-- from "COURSE_BOOKING"
-- inner join "USER" on "COURSE_BOOKING".user_id = "USER".id
-- inner join "COURSE" on "COURSE_BOOKING".course_id = "COURSE".id;

-- 5-4. 查詢：取得王小明所有的預約紀錄，包含取消預約的紀錄
select
  "USER".name as 客戶姓名,
  "COURSE".name as 課程名稱,
  booking_at as 預約時間,
  status as 預約狀態
from "COURSE_BOOKING"
inner join "USER" on "COURSE_BOOKING".user_id = "USER".id
inner join "COURSE" on "COURSE_BOOKING".course_id = "COURSE".id
where "USER".email = 'wXlTq@hexschooltest.io'
order by booking_at desc;

-- 5-5. 修改：`王小明` 現在已經加入直播室了，請在`COURSE_BOOKING`更新該筆預約資料（請注意，不要更新到已經取消的紀錄）：
    -- 1. 請在該筆預約記錄他的加入直播室時間 `join_at` 設為2024-11-25 14:01:59
    -- 2. 狀態`status` 設定為上課中
-- 資料整理 =====================
-- 王小明的課 and status = '即將授課'，修改多個欄位：join_at, status
update "COURSE_BOOKING"
set
  join_at = '2024-11-25 14:01:59',
  status = '上課中'
where user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
and status = '即將授課';
-- 顯示結果 =====================
-- select
--   "USER".name as 客戶名稱,
--   "COURSE".name as 課程名稱,
--   "COURSE_BOOKING".booking_at as 預約時間,
--   "COURSE_BOOKING".status as 預約狀態,
--   "COURSE_BOOKING".join_at as 加入時間
-- from "COURSE_BOOKING"
-- inner join "USER" on "COURSE_BOOKING".user_id = "USER".id
-- inner join "COURSE" on "COURSE_BOOKING".course_id = "COURSE".id;

-- 5-6. 查詢：計算用戶王小明的購買堂數，顯示須包含以下欄位： user_id , total。 (需使用到 SUM 函式與 Group By)
-- 資料整理 =====================
-- 王小明購買的總堂數
-- 🎯 "USER" u 資料表別名寫法
select
  user_id as 客戶編號,
  SUM(purchased_credits) as 購買總堂數,
  SUM(price_paid) as 購買總金額
from "CREDIT_PURCHASE" cp
where cp.user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
group by user_id;

-- 5-7. 查詢：計算用戶王小明的已使用堂數，顯示須包含以下欄位： user_id , total。 (需使用到 Count 函式與 Group By)
-- 資料整理 =====================
-- 👉 王小明的已使用堂數 = 王小明預約的課程 && status = '上課中'
select
  user_id,
  COUNT(*) as 已使用堂數 
from "COURSE_BOOKING"
where user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
and status = '上課中'
group by user_id;

-- 5-8. [挑戰題] 查詢：請在一次查詢中，計算用戶王小明的剩餘可用堂數，顯示須包含以下欄位： user_id , remaining_credit
    -- 提示：
    -- select ("CREDIT_PURCHASE".total_credit - "COURSE_BOOKING".used_credit) as remaining_credit, ...
    -- from ( 用戶王小明的購買堂數 ) as "CREDIT_PURCHASE"
    -- inner join ( 用戶王小明的已使用堂數) as "COURSE_BOOKING"
    -- on "COURSE_BOOKING".user_id = "CREDIT_PURCHASE".user_id;
-- 資料整理 =====================
-- 👉 王小明的剩餘可用堂數 = 王小明已購買堂數 - 已使用堂數
-- 👉 先新增欄位 total_credit, used_credit
-- select
--   ("CREDIT_PURCHASE".total_credit - "COURSE_BOOKING".used_credit) as remaining_credit
-- from (
--   select user_id, SUM(purchased_credits) as total_credit
--   from "CREDIT_PURCHASE"
--   where user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
--   group by user_id
--   ) as "CREDIT_PURCHASE"
-- inner join (
--   select user_id, COUNT(*) as used_credit
--   from "COURSE_BOOKING"
--   where user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io')
--   and status = '上課中'
--   group by user_id
-- ) as "COURSE_BOOKING"
-- on "COURSE_BOOKING".user_id = "CREDIT_PURCHASE".user_id;
-- ❌ 主要問題
-- 1. 兩個子查詢內 where 可以統一放到主查詢
-- 2. 當用戶沒有購買課程或沒有上課時，可能出現 NULL 問題，使用 COALESCE() 來處理
-- 3. INNER JOIN 可能會漏掉用戶，如果用戶有購買堂數，但還沒上過課，INNER JOIN 會導致該用戶不出現在結果中。改用 LEFT JOIN，確保即使用戶還沒開始上課，仍然能查出正確的 remaining_credit。
-- ✅ 解決方案
select
  cp.user_id,
  COALESCE(cp.total_credit, 0) - COALESCE(cb.used_credit, 0) as remaining_credit
from (
  select user_id, SUM(purchased_credits) as total_credit
  from "CREDIT_PURCHASE"
  group by user_id
  ) as cp
left join (
  select user_id, COUNT(*) as used_credit
  from "COURSE_BOOKING"
  where status = '上課中'
  group by user_id
) as cb
on cb.user_id = cp.user_id
where cp.user_id = (select id from "USER" where email = 'wXlTq@hexschooltest.io');


------------------------------------------------------------

-- ████████  █████   █     ███  
--   █ █   ██    █  █     █     
--   █ █████ ███ ███      ████  
--   █ █   █    ██  █     █   █ 
--   █ █   █████ █   █     ███  
-- ===================== ====================
-- 6. 後台報表
-- 6-1 查詢：查詢專長為重訓的教練，並按經驗年數排序，由資深到資淺（需使用 inner join 與 order by 語法)
-- 顯示須包含以下欄位： 教練名稱 , 經驗年數, 專長名稱

-- 6-2 查詢：查詢每種專長的教練數量，並只列出教練數量最多的專長（需使用 group by, inner join 與 order by 與 limit 語法）
-- 顯示須包含以下欄位： 專長名稱, coach_total

-- 6-3. 查詢：計算 11 月份組合包方案的銷售數量
-- 顯示須包含以下欄位： 組合包方案名稱, 銷售數量

-- 6-4. 查詢：計算 11 月份總營收（使用 purchase_at 欄位統計）
-- 顯示須包含以下欄位： 總營收

-- 6-5. 查詢：計算 11 月份有預約課程的會員人數（需使用 Distinct，並用 created_at 和 status 欄位統計）
-- 顯示須包含以下欄位： 預約會員人數
