
// for function "void TVPExecuteScript(const ttstr &, iTJSDispatch2 *, tTJSVariant *)"
// which is not defined in kirikiri 2.32 but defined in kirikiriZ.
// If the function is not defined, it will be XFR to
// "void TVPExecuteScript(const ttstr &, tTJSVariant *)"


// If this is defined,     will be built for KIRIKIRI_2.
// If this is NOT defined, will be built for the latest KIRIKIRI_2 or KIRIKIRI_Z.
#define KIRIKIRI_2




#ifdef KIRIKIRI_2

#define SWITCH_TVPEXECUTEEXPRESSION(content, context, result) \
	TVPExecuteExpression((content), (result))

#else

#define SWITCH_TVPEXECUTEEXPRESSION(content, context, result) \
	TVPExecuteExpression((content), (context), (result))

#endif
