@return cond="typeof(global.TJSFunctions) != 'undefined'"
;
; 2015/07/08	1.27	ignoreCR=false�ɑΉ�(���s���Ȃ��悤�ɂ�������)
; 2014/06/21	1.26	str2num()��min/max������ǉ�
; 2014/02/26	1.25	str2num()�ŃG���[�ɂȂ��Ă����̂��C��
; 2013/08/10	1.24	em()��emtype='stop'�̎���Exception�Œ�~����悤�C��
;			em()�̈�����errflg(def=1)��ǉ�
; 2013/07/30	1.23	em()��emtype='stop'�̎��ɂ�stop���Ȃ������̂��C��
; 2012/10/01	1.22	selectcopy_dic()��copyifvoid��numerize��ǉ�
;			numerize_dic()�ŁA�ϊ���RegExp��p����悤�ɕύX
;			showtickdiff() ��ǉ�
; 2012/09/25	1.21	selectcopy_dic()��dst/src��void�������炷��return����
;			�悤�ύX
; 2012/08/13	1.20	getLayersFromElm()��getLayerPageNamesFromElm()��ǉ�
; 2012/08/06	1.19	���N���X�Ɛe�N���X����肷��֐���ǉ�
; 2012/05/27	1.18	�����̃L�[��\������Ƃ��\�[�g����悤�ɕύX
; 2011/09/24	1.17	selectcopy_dic()�ŁAtypeof(src[key]) != 'undefined'��
;			src[key] !== void�ɖ߂����BKLayers��SliderTab�ŕs�s��
;			����������
; 2011/07/18	1.16	printObject()��recursive �I�v�V������ǉ��B�u�ċN�\��
;			���Ȃ��v�̂��I���ł���悤�ɂ����B
;			str2num()��ǉ�
;			selectcopy_dic()�ŁAsrc[key] !== void��
;			typeof(src[key]) != 'undefined'�ɕύX�B�u�l�͂��邯��
;			void�v�̎��𓦂��ʂ悤�ɂ��邽��
; 2011/05/30	1.15	printLayers()�ǉ�
; 2011/05/02	1.14	printObject()�Ŏ����L�[��/��:���܂܂��ꍇ�ɂ��Ή�
; 2011/02/14	1.13	getManLayerAbsolute(), getManKAGAbsolute() ��ǉ�
; 2011/01/17	1.12	marge_dic()�ŁAif�������[�v�O�ɏo���Č�����
; 2011/01/15	1.11	findStorage()�ŁA�g���q�����Ń}�b�`�����ꍇ���l��
; 2010/12/19	1.10	deletevoid_dic()�ǉ��B�������́u�L�[�͂��邯�ǒl��
;			void�v�̗v�f�� delete ����֐��B
;			setOptions_sub() �ɁAdeletevoid_dic���g�����ǂ�����
;			�t���O voidwrite ��ǉ�
;			printObject()�ŕ��J�b�R�̃^�u�ʒu�̊ԈႢ���C��
;			objectString() ��ǉ�
;			em() ��ǉ�
;			add_ary() ��ǉ�
;			evalkag() ��ǉ�
;			marge_dic()��setOptions_sub()��copy�t���O��ǉ�
; 2010/11/26	1.03	find_val() ��ǉ�
; 2010/11/22	1.02	selectcopy_dic() ��ǉ�
; 2010/08/13	1.01	setOptions_sub()�ł�elm��numerize����悤�ύX
;			numerize_dic() �̓��� dic===void �̗�O������ǉ�
;
@iscript


// ��̔z���ڑ�����
function add_ary(ary1=[], ary2=[])
{
	// �ꉞ�����ɁB
	for (var i = 0; i < ary2.count; i++)
		ary1.add(ary2[i]);
	return ary1;
}


// �n�b�V������L�[���������o���Ĕz���Ԃ�(perl �� keys()�Ɠ���)
function keys(dic)
{
	var ary = [];
	var ret = [];
	ary.assign(dic);
	// �ꉞ�����Ɏ��o��(���x�I�ɂ͕s�����������)
	for (var i = 0; i < ary.count; i += 2)
		ret.add(ary[i]);
	return ret;
}


// �n�b�V������w��l(val) �����L�[��Ԃ��Breturnary �Ȃ畡����ary�ŕԂ�
function find_val(dic=%[], val, returnary=false)
{
	var ary = [];
	var retary = [];

	ary.assign(dic);
	if (!returnary) {
		// �ꉞ�����ɏ�������(���x�I�ɂ͕s�����������)
		for (var i = 0; i < ary.count; i += 2)
			if (ary[i+1] == val)
				return ary[i];
	} else {
		// �ꉞ�����ɏ�������(���x�I�ɂ͕s�����������)
		for (var i = 0; i < ary.count; i += 2)
			if (ary[i+1] == val)
				retary.add(ary[i]);
	}
	return retary;
}


// ��������w�肵���L�[���폜����
function remove_keys(dic=%[], removekeys=[])
{
	var keyary = keys(dic);
	for (var i = keyary.count-1; i >= 0; i--) {
		var key = keyary[i];
		if (removekeys.find(key) >= 0)
			delete dic[key];
	}
	return dic;
}


// dic �� elm �𓝍����Adic ���㏑�����ĕԂ��B calc �� or �� and ��ς�����
// copy = true�ŁAassignStruct���g���ăR�s�[����
function marge_dic(dic=%[], elm=%[], calc='or', exceptkeys, copy=false)
{
	var ary = [];

	// copy�t���O�ɏ]���Aasssign()/assignStruct() ��ύX����
	var tmp = [];
	tmp.assign(elm);
	if (copy)
		ary.assignStruct(tmp);
	else
		ary.assign(tmp);

	var key;
	if (calc == 'or') {
		if (exceptkeys === void)
			for (var i = ary.count-2; i >= 0; i -= 2)
				dic[ary[i]] = ary[i+1];
		else
			for (var i = ary.count-2; i >= 0; i -= 2) {
				key = ary[i];
				if (exceptkeys.find(key) < 0)
					dic[key] = ary[i+1];
			}
	} else { // if (calc == 'and') 
		if (exceptkeys === void)
			for (var i = ary.count-2; i >= 0; i -= 2) {
				key = ary[i];
				if (typeof(dic[key]) != 'undefined')
					dic[key] = ary[i+1];
			}
		else
			for (var i = ary.count-2; i >= 0; i -= 2) {
				key = ary[i];
				if (exceptkeys.find(key) < 0)
					if (typeof(dic[key]) != 'undefined')
						dic[key] = ary[i+1];
			}
	}
        return dic;
}


// �����z�񒆂̒l�𐔒l�ɕϊ�����B�����w�肳��Ă��Ȃ���΁A�\�Ȃ�����
// string �� int �� real �֕ϊ����悤�Ƃ���
function numerize_dic(dic, intkeys = [], realkeys = [], strkeys = [])
{
	if (dic === void)
		return;

	var ary = [];
	ary.assign(dic);
	if (intkeys.count == 0 && realkeys.count == 0 && strkeys.count == 0) {
		// �L�[���w�肳��Ă��Ȃ���Ή\�Ȍ���int/real�ɕϊ�����
		var e = new RegExp('^(([0-9]+)|([0-9]+\\.[0-9]+)|(0x[0-9a-fA-F]+))$');
		for (var i = ary.count-2; i >= 0; i -= 2) {
			var val = ary[i+1];
			if (typeof(val) == 'String' && e.test(val))
				dic[ary[i]] = +val;
		}
	} else {
		// �L�[���w�肳��Ă���΂���ɏ]��
		for (var i = ary.count-2; i >= 0; i -= 2) {
			var key = ary[i];
			var val = ary[i+1];
			if (typeof(val) == 'String') {
				var str = trim(val);
				if (intkey.find(key) >= 0)
					dic[ary[i]] = int(val);
				else if (realkey.find(key) >= 0)
					dic[ary[i]] = real(val);
				else if (strkey.find(key) >= 0)
					dic[ary[i]] = stringl(val);
			}
		}
	}
	return dic;
}


// �������̎w��L�[�������R�s�[����(src.abc === void�̏ꍇ�R�s�[�ł��Ȃ�)
// ��numerize=true���Ƃ₽��Əd���̂ŁA����ς���L�[��numerize���邩
// �@�ǂ������f�������������B13000�v�f��selectcopy_dic=3899ms vs �����f
//   = 43ms ���炢�̍�������
function selectcopy_dic(obj, src, keyary, copyifvoid=false, numerize=false)
{
	if (obj === void || src === void)
		return;
	if (keyary === void)
		keyary = keys(src);

	var key, val, e;
	if (numerize) // ���̒�`�����\�d���̂ŏ����킯
		e = new RegExp('^(([0-9]+)|([0-9]+\\.[0-9]+)|(0x[0-9a-fA-F]+))$');
	for (var i = keyary.count-1; i >= 0; i--) {
		key = keyary[i];
		// if (typeof(src[key]) != 'undefined')
		// ����������void�R�s�[�ł��邪�Aelm = %[str:mp.str]��
		// �ǂ�mp.str���w�肳��ĂȂ��������ɒl��void�Őݒ肳
		// ��Ă��܂��̂ŁA���ɂ���
		if (typeof(src[key]) != 'undefined') {
			val = src[key];
			if (val !== void || copyifvoid)
				if (numerize && typeof(val) == 'String' &&
				    e.test(val))
					obj[key] = +val;
				else
					obj[key] = val;
		}
	}
	return obj;
}


// �����́Avoid �v�f(�L�[�͂���̂ɒl��void)���폜����
function deletevoid_dic(dic)
{
	var ary = keys(dic);
	for (var i = ary.count-1; i >= 0; i--)
		if (dic[ary[i]] === void)
			delete dic[ary[i]];
	return dic;
}


// marge_dic ��������ƕς��āAsetOptions_sub()������
function setOptions_sub(obj, elm, exceptkeys=[], voidwrite=false, copy=true)
{
	numerize_dic(elm);
	if (!voidwrite)
		deletevoid_dic(elm);
	// �f�t�H���g�� copy = true �ł��邱�Ƃɒ��ӁB�������Ȃ��ƁA
	// ���C���̎����v���p�e�B���R�s�[�������Ɍ����C����������ƃv���p�e�B��
	// �����邱�Ƃ����邽�߁B
	marge_dic(obj, elm, 'and', exceptkeys, copy);
}


// dic1 �� dic2 �𓝍����Adic2 �ŏ㏑�������V���� dic ��Ԃ��B
function create_dic(dic1=%[], dic2=%[], calc='or', exceptkeys=[])
{
	var tmp = %[];
	(Dictionary.assign incontextof tmp)(dic1);
	return marge_dic(tmp, dic2, calc, exceptkeys);
}


// �t�@�C�������݂��邩�ǂ����T���A���݂���� true ��Ԃ�
// �g���q�w�肪����΂��̊g���q�Ƃ̑g�ݍ��킹��T���B�g���q��'.'���Ŏw�肷��
function findStorage(fnam, exp)
{
	if (exp === void || Storages.isExistentStorage(fnam))
		return Storages.isExistentStorage(fnam);
	for (var i = exp.count-1; i >= 0; i--)
		if (Storages.isExistentStorage(fnam + exp[i]))
			return true;
	return false;
}


// �t�@�C�������݂��邩�ǂ����T���A�t���p�X(����X�g���[�W��)��Ԃ��B
// �g���q�w�肪����΂��̊g���q�Ƃ̑g�ݍ��킹��T���B�g���q��'.'���Ŏw�肷��
function findPlacedPath(fnam, exp)
{
	if (exp === void)
		return Storages.getPlacedPath(fnam);
	var ret;
	for (var i = exp.count-1; i >= 0; i--)
		if ((ret = Storages.getPlacedPath(fnam + exp[i])) != "")
			return ret;
	return "";
}


// �I�u�W�F�N�g(global.xxxx�ŎQ�Ƃł������)��n���ƃI�u�W�F�N�g�������Ԃ�
function objectString(obj)
{
	var ary = [];
	ary.assign(global);
	for (var i = ary.count-2; i >= 0; i -= 2) {
		if (ary[i+1] == obj)
			return string(ary[i]);
	}
	return "";
}


// ����I�u�W�F�N�g�E�z��E�n�b�V���̒��g��S���\������c�̃T�u���[�`��
// �����̓I�u�W�F�N�g���̂��̂ł͂Ȃ��āA������ł��邱�Ƃɒ��ӁB
function printObject_sub(objstr, indent=0, printedObject=[], recursive=true)
{
	var obj  = Scripts.eval(objstr);
	var type = typeof(obj);
	var tabs = "";
	for (var i = indent; i > 0; i--)
		tabs += "    ";	// 4TAB�ŁB

	// void �Ƃ� null �̎�
	if (obj === void) {
		dm(tabs + objstr + '(' + type + ') = (void)');
		return;
	}
	if (obj == null) {
		dm(tabs + objstr + '(' + type + ') = (null)');
		return;
	}
	if (type == 'Integer' || type == 'Real' || type == 'String' ||
	    type == 'Octet') {
		// �����E�����E������̎�
		dm(tabs + objstr + ' = (' + type + ') ' + obj);
		return;
	}
	if (obj instanceof "Function") { // ��Ƀ`�F�b�N����K�v����
		// �֐��̏ꍇ
		dm(tabs + objstr + ' = (Function) ' + obj);
		return;
	}

	// ���ɕ\���ς݂��ǂ����`�F�b�N�A�\���ς݂Ȃ�ȍ~�������Ȃ�
	if (printedObject.find(obj) >= 0) {
		dm(tabs + objstr + ' = (' + type + ') (Recursive displayed)');
		return;
	}
	printedObject.add(obj);	// �\���ς݂ɂ���

	if (obj instanceof "Array") {
		// �z��̎�
		dm(tabs + objstr + ' = (Array) [');
		for (var i = 0; i < obj.count; i++)
			if (!recursive)
				dm(tabs+'    '+objstr+'['+i+'] = ' + obj[i]);
			else
				printObject_sub(objstr+'['+i+']', indent+1);
	} else if (obj instanceof "Dictionary") {
		// �����z��̎�
		dm(tabs + objstr + ' = (Dictionary) %[');
		var keyary = keys(obj);
		keyary.sort();
		for (var i = 0; i < keyary.count; i++) {
			if (!recursive)
				dm(tabs+'    '+objstr+'['+keyary[i]+'] = ' + obj[keyary[i]]);
			else if (/^[0-9]/.test(keyary[i])) // ���l�͓��ʈ���
				printObject_sub(objstr+'['+keyary[i]+']',indent+1);
			else
				printObject_sub(objstr+'["'+keyary[i]+'"]',indent+1);
		}
	} else if (type == "Object") {
		// �I�u�W�F�N�g�̎�
		dm(tabs + objstr + ' = (Object) %[');
		var keyary = keys(obj);
		keyary.sort();
		for (var i = 0; i < keyary.count; i++) {
			if (!recursive)
				dm(tabs+'    '+objstr+'['+keyary[i]+'] = ' + obj[keyary[i]]);
			if (/^[0-9]/.test(keyary[i])) // ���l�̎��͓��ʈ���
				printObject_sub(objstr+'['+keyary[i]+']',indent+1);
			else
				printObject_sub(objstr+'["'+keyary[i]+'"]',indent+1);
		}
	} else {
		dm(objstr + '###################################### error');
	}
	dm(tabs + ']');
}

//var printObject_printedObject;

// ����I�u�W�F�N�g�E�z��E�n�b�V���̒��g��S���\������B
// ����܂�f�J���I�u�W�F�N�g��\�����悤�Ƃ���ƃX�^�b�N�s���ɂȂ�B
function printObject(objstr, recursive=true)
{
	// objstr����Ȃ���obj���w��ł���悤�ɂ��悤�Ƃ��v�������A
	// obj����objstr�ւ̕ϊ����ł��Ȃ��̂Ńp�X�B
	printObject_sub(objstr, 0, [], recursive);
}


// �G���[���b�Z�[�W��\������B
// sf.emtype �ɉ����A���b�Z�[�W���c�������E�|�b�v�A�b�v���� ���I���ł���B
// sf.emtype: void   = �G���[��System.inform()�ŕ\�����邪��~���Ȃ�
//            'stop' = �G���[���ɂ͒�~
//            ��     = dm()�̂�
function em(str, errflg=1)
{
	if (!errflg) // �\������K�v���Ȃ���΂Ȃɂ����Ȃ�
		return;
	Debug.message(str);	// ���O�Ƀ��b�Z�[�W���c��
	if (sf.emtype === void) {
		var s = "\n(sf.emtype���`����ƕ\������Ȃ��Ȃ�܂�)";
		System.inform(str + s);
	}
	if (sf.emtype !== void && sf.emtype == 'stop') {
		throw new Exception(str + '\n');
		// ���ꂾ�Ƌg���g���R���\�[������em()�����s���Ă��|�b�v�A�b�v��
		// �\������Ȃ��̂����c�܂��c�������c�B
	}
}


// kag�X�N���v�g����������s����
// �}�N�����g�p�\�����A[wt][wait]�Ȃǂ̑҂������͎g�p�ł��Ȃ�
function kageval(kagscript)
{
	var tmp = kag.onConductorScenarioLoad;
	kag.onConductorScenarioLoad = function(name){ return name; };
	kag.process("\n"+kagscript, "");
	kag.onConductorScenarioLoad = tmp;
}


// ���郌�C���̎q���C���̍ō�absolute������
function getMaxLayerAbsolute(l)
{
	var abs = -1;
	if (!l.isPrimary && l.parent.absoluteOrderMode)
		abs = l.absolute;
	for (var i = l.children.count-1; i >= 0; i--) {
		var newabs = getMaxLayerAbsolute(l.children[i]);
		if (abs < newabs)
			abs = newabs;
	}
	return abs;
}


// KAG�E�B���h�E�̎q���C���̍ō�absolute������
function getMaxKAGAbsolute()
{
	var foreabs = getMaxLayerAbsolute(kag.fore.base);
	var backabs = getMaxLayerAbsolute(kag.back.base);
	return (foreabs >= backabs) ? foreabs+1 : backabs+1;
}

// KAG�E�B���h�E�̊K�w�֌W��\��(sub)
function printLayers_sub(layer, indent=0, cnum=0)
{
	var lnum = 1;
	var tabs = "";
	for (var i = indent; i > 0; i--)
		tabs += "    ";	// 4TAB�ŁB
	if (typeof(layer.classid) == 'undefined' || layer.classid === void)
		dm(tabs + '['+cnum+']: name = ' + layer.name + ', children = ' + layer.children.count);
	else
		dm(tabs + '['+cnum+']: name = ' + layer.name + ', children = ' + layer.children.count + ', classid = ' + layer.classid);
	for (var i = 0; i < layer.children.count; i++)
		lnum += printLayers_sub(layer.children[i], indent+1, i);
	return lnum;
}

// KAG�E�B���h�E�̊K�w�֌W��\��
function printLayers(layer)
{
	var lnum;
	if (layer !== void) {
		dm('layers: ###############################################');
		lnum = lnum = printLayers_sub(layer);
		dm('layer number = ' + lnum);
	} else {
		dm('kag.fore.base layers: #################################');
		lnum = printLayers_sub(kag.fore.base);
		dm('fore layer number = ' + lnum);
		dm('kag.back.base layers: #################################');
		lnum = printLayers_sub(kag.back.base);
		dm('back layer number = ' + lnum);
	}
}


// ������𐔒l�ɕϊ��B�ϊ��G���[�ƂȂ�����f�t�H���g�l��Ԃ��Ƃ��낪�قȂ�
function str2num(str, def=0, min, max)
{
	if (str === void)
		return +def;
	var ret = +Scripts.eval(str);
	if (min !== void && ret < +min)
		return +min;
	if (max !== void && +max < ret)
		return +max;
	return ret;
}


// ���N���X�̖��O�𓾂�
function getClassName(obj)
{
	return Scripts.getClassNames(obj)[0];
}

// �e�N���X�𓾂�(�P���p���̏ꍇ�̂�)
function getSuperClass(obj)
{
	var cls = Scripts.getClassNames(obj)[1];
	return cls === void ? void : global[cls];
}


// elm �ɉ����ă��C����Ԃ��Belm.layer === void �� elm.page === void �������A
// ���̏ꍇ�͑Ώۂ�S���C���A�S�y�[�W�Ƃ���
function getLayersFromElm(elm = %[])
{
	if (elm.page === void || elm.page == 'both') {
		var fl = getLayersFromElm(%[layer:elm.layer, page:'fore']);
		var bl = getLayersFromElm(%[layer:elm.layer, page:'back']);
		return add_ary(fl, bl);
	}
	if (elm.layer === void)
		return kag[elm.page].layers;
	// page!==void, layer!==void�̏ꍇ
	return [kag[elm.page].layers[string(elm.layer)]];
}

// elm �ɉ����ă��C���ƃy�[�W���̃y�A��v�f�Ƃ���z���Ԃ��Belm.layer === void
// �� elm.page === void �������A���̏ꍇ�͑Ώۂ�S���C���A�S�y�[�W�Ƃ���
function getLayerPageNamesFromElm(elm = %[])
{
	if (elm.page === void || elm.page == 'both') {
		var fl, bl;
		fl = getLayerPageNamesFromElm(%[layer:elm.layer, page:'fore']);
		bl = getLayerPageNamesFromElm(%[layer:elm.layer, page:'back']);
		return add_ary(fl, bl);
	}
	var ret = [];
	if (elm.layer === void) {
		for (var i = 0; i < kag[elm.page].layers.count; i++)
			ret.add(%[layer:string(i), page:elm.page]);
		return ret;
	}
	return [%[layer:elm.layer, page:elm.page]];
}


// �O�񂩂�̍�������(1/1000�b�P��)��\������
tf.showtickdiff_ticksaver = System.getTickCount();
function showtickdiff(tag = "", prevtick)
{
	var diff, curtick = System.getTickCount();
	if (prevtick !== void) {
		diff = curtick - prevtick;
	} else {
		diff = curtick - tf.showtickdiff_ticksaver;
		tf.showtickdiff_ticksaver = curtick;
	}
	dm(string(tag) + ': tickdiff: ' + diff);
	return curtick;
}


// ���̊֐��Q�ǂݍ��ݍς݃t���O
global.TJSFunctions = true;

@endscript
;
;
@return
