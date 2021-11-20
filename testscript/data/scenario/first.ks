@call storage=TJSFunctions.ks
;
@iscript
property lf { getter { return kag.conductor.currentLocalVariables; } }
kag.conductor.debugLevel = 4;
@endscript
;
; マクロprintlf：現在のローカル変数を表示
@macro name=printlf
@eval exp="printObject('lf')"
@endmacro
;
; マクロprintlf：全てのローカル変数を表示
@macro name=printlfall
@eval exp="printObject('kag.conductor.localVariables')"
@endmacro
;
; マクロ errend：ローカル変数の値の予定値と違った場合に終了する
@macro name=errend errmsg="ローカル変数値不一致：" varname=void varval=void
@printlfall
@eval exp="mp.errmsg += mp.varname + ' != ' + mp.varval"
エラー：[&mp.errmsg](=[&"lf[mp.varname]"])
@s
@endmacro
;
@nowait
*start|開始
@printlfall
[startanchor]\
テストを開始します。各テストでエラーが出ないか、krkr.exeの使用メモリ量が\
著しく増加していないか確認してください。
クリックでテスト開始
[p][cm]\
;
@localvar i=1000
;*macrotest1|マクロ登録テスト
マクロ登録テスト([&lf.i]回) ...
[while exp=lf.i>0 each=lf.i--]\
	[eval exp="lf.macro_name = 'macro_'+lf.i"]\
	@macro name=$macro_name arg=$i
		@&lf.i
	@endmacro
[endwhile]\
完了
[p][cm]\
;
;
@localvar i=1000
*macrotest2|マクロ重複登録テスト
@printlfall
マクロ重複登録テスト([&lf.i]回) ...
*macrotest_loop
@macro name=tempmacro
	@eval exp=1
@endmacro
@jump target=*macrotest_loop cond="lf.i-- >= 0"
完了
@printlfall
[p][cm]\
;
;
@localvar i=1000
*pmacrotest|pマクロ登録テスト
[[pmacro]登録テスト([&lf.i]回) ...
[while exp=lf.i>0 each=lf.i--]\
	[eval exp="lf.pmacro_name = 'macro_'+lf.i"]\
	@pmacro name=$pmacro_name arg1=$i arg2=&lf.i+1
[endwhile]\
完了
[p][cm]\
;
;
@localvar testlocalval=testlocalval
*callsavetest|call先でのセーブテスト
@printlfall
call先でのセーブテスト
@call target=*callsavetest_subroutine i=0 j=1 k=2
;
;
@localvar i=100
*calltest|callテスト
@printlfall
call連続呼び出しテスト([&lf.i]回) ...
*calltest_loop
@call target=*calltest_subroutine
@jump target=*calltest_loop cond="lf.i-- >= 0"
完了
[p][cm]\
;
;
@localvar imax=100 jmax=10
*whiletest|whileループテスト
@printlfall
whileループテスト([&lf.imax]x[&lf.jmax]回) ...
@while init=lf.i=0 exp=lf.i<lf.imax each=lf.i++
	@while init=lf.j=0 exp=lf.j<lf.jmax each=lf.j++
	@endwhile
@endwhile
完了
[p][cm]\
;
;
*localvartest|ローカル変数/whileループテスト
@printlfall
ローカル変数/whileループテスト ...
;
@localvar i=3 count=0
@printlf
@errend varname=lf.i varval=3 cond="lf.i != 3"
@pushlocalvar copyvar abc=2
@errend varname=i varval="!void" cond="lf.i === void"
@errend varname=abc varval=2 cond="lf.abc != 2"
@while init=lf.i=0 exp=lf.i<100 each=lf.i++
	@localvar count=&+lf.count+1
	@errend varname=abc varval=2 cond="lf.abc != 2"
	@errend varname=k varval=void cond="lf.k !== void"
	@pushlocalvar i=20000
	@while init=lf.k=0 exp=lf.k<10 each=lf.k++
		@errend varname=i varval=20 cond="lf.i != 20000"
		@pushlocalvar copyvar abc=3
			@errend varname=i varval=20000 cond="lf.i != 20000"
			@errend varname=abc varval=3 cond="lf.abc != 3"
			@tempmacro var1=ss
		@poplocalvar
		@errend varname=i varval=20000 cond="lf.i != 20000"
		@errend varname=abc varval=(void) cond="lf.abc !== void"
	@endwhile
	@poplocalvar
	@errend varname=i varval=20 cond="lf.i == 20000"
	@errend varname=abc varval=2 cond="lf.abc != 2"
	@errend varname=k varval=(void) cond="lf.k !== void"
@endwhile
@errend varname=abc varval=2 cond="lf.abc != 2"
@errend varname=count varval=100 cond="lf.count != 100"
@poplocalvar
@errend varname=count varval=0 cond="lf.count != 0"
;
完了
[p][cm]\
;
;
@localvar i=1000
whileループ強制退去テスト([&lf.i]回) ...
*whileexit|whileループ強制退去テスト
@localvar whilestackdepth=&kag.conductor.whileStackDepth
@errend varname=whilestackdepth varval=0 cond="lf.whilestackdepth != 0"
@while exp=1
	@while exp=1
		@while exp=1
			@while exp=1
				@jump target=*whileexit cond=--lf.i>0
				@localvar whilestackdepth=&kag.conductor.whileStackDepth
				@errend varname=whilestackdepth varval=4 cond="lf.whilestackdepth != 4"
				@break
			@endwhile
			@localvar whilestackdepth=&kag.conductor.whileStackDepth
			@errend varname=whilestackdepth varval=3 cond="lf.whilestackdepth != 3"
			@break
		@endwhile
		@localvar whilestackdepth=&kag.conductor.whileStackDepth
		@errend varname=whilestackdepth varval=2 cond="lf.whilestackdepth != 2"
		@break
	@endwhile
	@localvar whilestackdepth=&kag.conductor.whileStackDepth
	@errend varname=whilestackdepth varval=1 cond="lf.whilestackdepth != 1"
	@break
@endwhile
@localvar whilestackdepth=&kag.conductor.whileStackDepth
@errend varname=whilestackdepth varval=0 cond="lf.whilestackdepth != 0"
完了
[p][cm]\
;
;
@localvar i=1000
while/call強制退去テスト([&lf.i]回) ...
*whilecallexit|while/all強制退去テスト
@while exp=--lf.i>0
	@call target=*whilecallexit_subroutine i=$i
	@jump target=*whilecallexit
@endwhile
完了
[p][cm]\
;
;
テスト終了。エラーはありませんでした。
[s]


*callsavetest_subroutine|callセーブテスト
ここでセーブしてください。
@printlfall
[p][cm]\
@return


*calltest_subroutine
@eval exp=lf.calltestafterlabel='abc'
@return

*whilecallexit_subroutine
;二回に一回はtarget付きreturnする
@return target=*whilecallexit cond=lf.i%2==0
@return

