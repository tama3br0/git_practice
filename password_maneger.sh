#!/bin/bash

# パスワードデータを保存するファイル
password_file="passwords.txt"
# 暗号化されたファイル
encrypted_file="passwords.gpg"

# パスワードを保存
save_password() {
    echo "サービス名を入力してください："
    read -p "サービス名: " service
    read -p "ユーザー名: " username
    read -s -p "パスワード: " password
    echo ""
    
    # パスワード情報をファイルに保存
    echo "$service $username $password" >> "$password_file"
    
    # パスワードファイルを暗号化
    gpg --output "$encrypted_file" --encrypt --recipient your-email@example.com "$password_file"
    
    echo "パスワードの追加と暗号化は成功しました."
    echo "次の選択肢から入力してください (Add Password/Get Password/Exit):"
}

# パスワードを取得
get_password() {
    echo "サービス名を入力してください："
    read -p "サービス名: " service
    
    # 暗号化されたファイルを復号化
    gpg --output "$password_file" --decrypt "$encrypted_file"
    
    data=$(grep "$service" "$password_file")
    
    # 復号化後、パスワードファイルを削除
    rm "$password_file"
    
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
    
    echo "次の選択肢から入力してください (Add Password/Get Password/Exit):"
}

# ウェルカムメッセージを表示
echo "パスワードマネージャーへようこそ！"
echo "次の選択肢から入力してください (Add Password/Get Password/Exit):"

while true; do
    read -p "選択してください: " choice

    case $choice in
        "Add Password")
            save_password
            ;;
        "Get Password")
            get_password
            ;;
        "Exit")
            echo "Thank you!"
            exit 0
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください."
            ;;
    esac
done
