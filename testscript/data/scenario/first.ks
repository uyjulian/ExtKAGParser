@call storage=TJSFunctions.ks
;
@iscript
property lf { getter { return kag.conductor.currentLocalVariables; } }
kag.conductor.debugLevel = 4;
@endscript
;
; �}�N��printlf�F���݂̃��[�J���ϐ���\��
@macro name=printlf
@eval exp="printObject('lf')"
@endmacro
;
; �}�N��printlf�F�S�Ẵ��[�J���ϐ���\��
@macro name=printlfall
@eval exp="printObject('kag.conductor.localVariables')"
@endmacro
;
; �}�N�� errend�F���[�J���ϐ��̒l�̗\��l�ƈ�����ꍇ�ɏI������
@macro name=errend errmsg="���[�J���ϐ��l�s��v�F" varname=void varval=void
@printlfall
@eval exp="mp.errmsg += mp.varname + ' != ' + mp.varval"
�G���[�F[&mp.errmsg](=[&"lf[mp.varname]"])
@s
@endmacro
;
@nowait
*start|�J�n
@printlfall
[startanchor]\
�e�X�g���J�n���܂��B�e�e�X�g�ŃG���[���o�Ȃ����Akrkr.exe�̎g�p�������ʂ�\
�������������Ă��Ȃ����m�F���Ă��������B
�N���b�N�Ńe�X�g�J�n
[p][cm]\
;
@localvar i=1000
;*macrotest1|�}�N���o�^�e�X�g
�}�N���o�^�e�X�g([&lf.i]��) ...
[while exp=lf.i>0 each=lf.i--]\
	[eval exp="lf.macro_name = 'macro_'+lf.i"]\
	@macro name=$macro_name arg=$i
		@&lf.i
	@endmacro
[endwhile]\
����
[p][cm]\
;
;
@localvar i=1000
*macrotest2|�}�N���d���o�^�e�X�g
@printlfall
�}�N���d���o�^�e�X�g([&lf.i]��) ...
*macrotest_loop
@macro name=tempmacro
	@eval exp=1
@endmacro
@jump target=*macrotest_loop cond="lf.i-- >= 0"
����
@printlfall
[p][cm]\
;
;
@localvar i=1000
*pmacrotest|p�}�N���o�^�e�X�g
[[pmacro]�o�^�e�X�g([&lf.i]��) ...
[while exp=lf.i>0 each=lf.i--]\
	[eval exp="lf.pmacro_name = 'macro_'+lf.i"]\
	@pmacro name=$pmacro_name arg1=$i arg2=&lf.i+1
[endwhile]\
����
[p][cm]\
;
;
@localvar testlocalval=testlocalval
*callsavetest|call��ł̃Z�[�u�e�X�g
@printlfall
call��ł̃Z�[�u�e�X�g
@call target=*callsavetest_subroutine i=0 j=1 k=2
;
;
@localvar i=100
*calltest|call�e�X�g
@printlfall
call�A���Ăяo���e�X�g([&lf.i]��) ...
*calltest_loop
@call target=*calltest_subroutine
@jump target=*calltest_loop cond="lf.i-- >= 0"
����
[p][cm]\
;
;
@localvar imax=100 jmax=10
*whiletest|while���[�v�e�X�g
@printlfall
while���[�v�e�X�g([&lf.imax]x[&lf.jmax]��) ...
@while init=lf.i=0 exp=lf.i<lf.imax each=lf.i++
	@while init=lf.j=0 exp=lf.j<lf.jmax each=lf.j++
	@endwhile
@endwhile
����
[p][cm]\
;
;
*localvartest|���[�J���ϐ�/while���[�v�e�X�g
@printlfall
���[�J���ϐ�/while���[�v�e�X�g ...
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
����
[p][cm]\
;
;
@localvar i=1000
while���[�v�����ދ��e�X�g([&lf.i]��) ...
*whileexit|while���[�v�����ދ��e�X�g
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
����
[p][cm]\
;
;
@localvar i=1000
while/call�����ދ��e�X�g([&lf.i]��) ...
*whilecallexit|while/all�����ދ��e�X�g
@while exp=--lf.i>0
	@call target=*whilecallexit_subroutine i=$i
	@jump target=*whilecallexit
@endwhile
����
[p][cm]\
;
;
�e�X�g�I���B�G���[�͂���܂���ł����B
[s]


*callsavetest_subroutine|call�Z�[�u�e�X�g
�����ŃZ�[�u���Ă��������B
@printlfall
[p][cm]\
@return


*calltest_subroutine
@eval exp=lf.calltestafterlabel='abc'
@return

*whilecallexit_subroutine
;���Ɉ���target�t��return����
@return target=*whilecallexit cond=lf.i%2==0
@return

