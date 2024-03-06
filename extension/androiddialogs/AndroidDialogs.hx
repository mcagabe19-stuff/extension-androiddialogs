package extension.androiddialogs;

#if (!android && !native && macro)
#error 'extension-androiddialogs is not supported on your current platform'
#end

import lime.system.JNI;

class AndroidDialogs {
	public static var LENGTH_SHORT = 1;
	public static var LENGTH_LONG = 2;

	public static var haxeObj:CallbackHandler = new CallbackHandler();

	@:noCompletion private static var showToast_jni:Dynamic = JNI.createStaticMethod("org/haxe/extension/AndroidDialogs", "showToast", "(Ljava/lang/String;I)V");
	@:noCompletion private static var showAlertDialog_jni:Dynamic = JNI.createStaticMethod("org/haxe/extension/AndroidDialogs", "showAlertDialog", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");
	@:noCompletion private static var showAlertSelectOption_jni:Dynamic = JNI.createStaticMethod("org/haxe/extension/AndroidDialogs", "showDialogSelectSimpleRadio", "(Ljava/lang/String;[Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");
	@:noCompletion private static var showAlertMultipleSelectOption_jni:Dynamic = JNI.createStaticMethod("org/haxe/extension/AndroidDialogs", "showDialogSelectMultiple", "(Ljava/lang/String;[Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");

	public static function showToast(message:String, duration:Int):Void {
		if (duration < 1 && duration > 2)
			duration = 2;

		showToast_jni(message, duration);
	}

	public static function showAlertDialog(title:String = "Title", message:String = "Message", confirmtext:String = "Confirm Button Text", canceltext:String = "Cancel Button Text"):Void
		showAlertDialog_jni(title, message, confirmtext, canceltext, haxeObj);

	public static function showAlertSelectOption(title:String = "Title", listItems:Array<String>):Void
		showAlertSelectOption_jni(title, listItems, haxeObj);

	public static function showAlertMultipleSelectOption(title:String = "Title", listItems:Array<String>):Void {
		showAlertMultipleSelectOption_jni(title, listItems, haxeObj);
}

private class CallbackHandler {
	public var answerDialog:String;
	public var answerOptionSelected:String;
	public var answersOptionsMultipleSelected:Array<String>;

	public function new() {}

	public function onMessageReceived(msg:String):Void
		answerDialog = msg;

	public function onOptionSelected(msg:String):Void
		answerOptionSelected = msg;

	public function onOptionMultipleSelected(msg:Dynamic):Void
		answersOptionsMultipleSelected = msg;
}
