#!/bin/bash
# macOS で Igor Pro 8 の Igor Procedures に、この手順ファイルへの Finder エイリアスを置く。

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "このスクリプトは macOS 専用です。" >&2
	exit 1
fi

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_ipf="${repo_root}/uv_vis_analyzer.ipf"
procedures_dir="${HOME}/Documents/WaveMetrics/Igor Pro 8 User Files/Igor Procedures"

if [[ ! -f "$source_ipf" ]]; then
	echo "手順ファイルが見つかりません: ${source_ipf}" >&2
	exit 1
fi

if [[ ! -d "$procedures_dir" ]]; then
	echo "Igor Procedures フォルダが見つかりません: ${procedures_dir}" >&2
	exit 1
fi

procedures_dir="$(cd "$procedures_dir" && pwd)"
source_ipf="$(cd "$(dirname "$source_ipf")" && pwd)/$(basename "$source_ipf")"

version=""
while IFS= read -r line || [[ -n "$line" ]]; do
	case "$line" in
		*ksUVVisAnalyzerVersion*)
			version="${line#*\"}"
			version="${version%%\"*}"
			if [[ -n "$version" && "$version" != "$line" ]]; then
				break
			fi
			version=""
			;;
	esac
done < "$source_ipf"

if [[ -z "$version" ]]; then
	echo "ksUVVisAnalyzerVersion を読み取れませんでした: ${source_ipf}" >&2
	exit 1
fi

case "$version" in
	*[!0-9A-Za-z._-]*)
		echo "バージョン文字列がファイル名に使えません: ${version}" >&2
		exit 1
		;;
esac

alias_name="uv_vis_analyzer_v_${version//./_}.ipf"
alias_path="${procedures_dir}/${alias_name}"

echo "バージョン: ${version}"
echo "エイリアス: ${alias_path}"
echo "参照先: ${source_ipf}"

others=()
while IFS= read -r -d '' path; do
	others+=("$path")
done < <(find "$procedures_dir" -maxdepth 1 -name 'uv_vis_analyzer_v_*' ! -name "$alias_name" -print0)

if ((${#others[@]} > 0)); then
	echo
	echo "他のバージョンが見つかりました:"
	for path in "${others[@]}"; do
		if [[ -L "$path" ]]; then
			echo "  ${path} -> $(readlink "$path")"
		else
			echo "  ${path}"
		fi
	done
	echo
	answer=""
	if ! read -r -p "これらを削除しますか? [y/N]: " answer; then
		echo "回答が得られなかったため、他のバージョンは削除しません。"
		answer=""
	fi
	case "$answer" in
		y|Y|yes|YES|はい)
			for path in "${others[@]}"; do
				parent="$(cd "$(dirname "$path")" && pwd)"
				name="$(basename "$path")"
				if [[ "$parent" != "$procedures_dir" || "$name" == "$alias_name" || "$path" == "$source_ipf" ]]; then
					echo "対象外なので削除しません: ${path}" >&2
					continue
				fi
				case "$name" in
					uv_vis_analyzer_v_*) ;;
					*)
						echo "対象外なので削除しません: ${path}" >&2
						continue
						;;
				esac
				rm -f -- "$path"
				echo "削除しました: ${path}"
			done
			;;
		*)
			echo "他のバージョンは残します。"
			;;
	esac
fi

if [[ -d "$alias_path" && ! -L "$alias_path" ]]; then
	echo "エイリアスの置き場所がディレクトリです: ${alias_path}" >&2
	exit 1
fi

if [[ -e "$alias_path" || -L "$alias_path" ]]; then
	rm -f -- "$alias_path"
	echo "現在のバージョンのエイリアスを置き換えます: ${alias_path}"
fi

if ! osascript - "$source_ipf" "$procedures_dir" "$alias_name" >/dev/null <<'EOF'
on run argv
	set sourcePath to item 1 of argv
	set destPath to item 2 of argv
	set aliasName to item 3 of argv
	tell application "Finder"
		set sourceFile to POSIX file sourcePath as alias
		set destFolder to POSIX file destPath as alias
		make new alias file at destFolder to sourceFile with properties {name:aliasName}
	end tell
end run
EOF
then
	echo "エイリアスの作成に失敗しました。" >&2
	exit 1
fi

if [[ ! -f "$alias_path" ]]; then
	echo "エイリアスが作成されていません: ${alias_path}" >&2
	exit 1
fi

echo "エイリアスを作成しました: ${alias_path}"
