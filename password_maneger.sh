#!/bin/bash

# パスワードデータを保存するファイル
password_file="passwords.txt"

# パスワードを保存
save_password() {
    echo "サービス名を入力してください："
    read -p "サービス名: " service
    read -p "ユーザー名: " username
    read -s -p "パスワード: " password
    echo ""
    
    # 既存の情報があるか確認
    existing_data=$(grep "$service" "$password_file")
    if [ -n "$existing_data" ]; then
        # 既存の情報を削除
        sed -i "/$service/d" "$password_file"
    fi
    
    echo "パスワードの追加は成功しました。"
    echo "次の選択肢から入力してください (Add Password/Get Password/Change Password/Exit):"
    echo ""
    echo "$service $username $password" >> "$password_file"
}

# パスワードを取得
get_password() {
    echo "サービス名を入力してください："
    read -p "サービス名: " service
    data=$(grep "$service" "$password_file")
    if [ -n "$data" ]; then
        username=$(echo "$data" | awk '{print $2}')
        password=$(echo "$data" | awk '{print $3}')
        echo ""
        echo "サービス名：$service"
        echo "ユーザー名：$username"
        echo "パスワード：$password"
    else
        echo ""
        echo "そのサービスは登録されていません。"
    fi
    echo "次の選択肢から入力してください (Add Password/Get Password/Change Password/Exit):"
}

# パスワードを変更
change_password() {
    echo "サービス名を入力してください："
    read -p "サービス名: " service
    data=$(grep "$service" "$password_file")
    if [ -n "$data" ]; then
        echo "現在の情報："
        username=$(echo "$data" | awk '{print $2}')
        password=$(echo "$data" | awk '{print $3}')
        echo "サービス名：$service"
        echo "ユーザー名：$username"
        echo "パスワード：$password"
        echo ""
        
        read -p "新しいユーザー名: " new_username
        read -s -p "新しいパスワード: " new_password
        echo ""
        
        # 既存の情報を削除
        sed -i "/$service/d" "$password_file"
        
        echo "パスワードの変更は成功しました。"
        echo "次の選択肢から入力してください (Add Password/Get Password/Change Password/Exit):"
        echo ""
        echo "$service $new_username $new_password" >> "$password_file"
    else
        echo ""
        echo "そのサービスは登録されていません。"
    fi
    echo "次の選択肢から入力してください (Add Password/Get Password/Change Password/Exit):"
}

# ウェルカムメッセージを表示
echo "パスワードマネージャーへようこそ！"
echo "次の選択肢から入力してください (Add Password/Get Password/Change Password/Exit):"

while true; do
    read -p "選択してください: " choice

    case $choice in
        "Add Password")
            save_password
            ;;
        "Get Password")
            get_password
            ;;
        "Change Password")
            change_password
            ;;
        "Exit")
            echo "Thank you!"
            exit 0
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Change Password/Exit から入力してください."
            ;;
    esac
done
