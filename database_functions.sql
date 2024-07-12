-- ユーザー名をusersテーブルにコピーするDatabase Functionを定義
create or replace function public.handle_new_user() returns trigger as $$
    begin
        insert into public.users(auth_id, nickname)
        values(new.id, new.raw_user_meta_data->>'username');

        return new;
    end;
$$ language plpgsql security definer;

-- ユーザー作成時に`handle_new_user`を呼ぶためのトリガーを定義
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function handle_new_user();
