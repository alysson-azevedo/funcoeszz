# ----------------------------------------------------------------------------
# http://www.ibiblio.org
# Procura documentos do tipo HOWTO.
# Uso: zzhowto [--atualiza] palavra
# Ex.: zzhowto apache
#      zzhowto --atualiza
#
# Autor: Thobias Salazar Trevisan, www.thobias.org
# Desde: 2002-08-27
# Versão: 2
# Licença: GPL
# ----------------------------------------------------------------------------
zzhowto ()
{
	zzzz -h howto "$1" && return

	local padrao
	local cache=$(zztool cache howto)
	local url='http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/'

	# Verificação dos parâmetros
	test -n "$1" || { zztool -e uso howto; return 1; }

	# Força atualização da listagem apagando o cache
	if test "$1" = '--atualiza'
	then
		zztool atualiza howto
		shift
	fi

	padrao=$1

	# Se o cache está vazio, baixa listagem da Internet
	if ! test -s "$cache"
	then
		$ZZWWWDUMP "$url" |
			grep 'text/html' |
			sed 's/^  *//; s/ [0-9][0-9]:.*//' > "$cache"
	fi

	# Pesquisa o termo (se especificado)
	if test -n "$padrao"
	then
		zztool eco "$url"
		grep -i "$padrao" "$cache"
	fi
}
