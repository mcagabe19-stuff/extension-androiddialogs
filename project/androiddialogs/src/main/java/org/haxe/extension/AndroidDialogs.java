package org.haxe.extension;

import org.haxe.lime.HaxeObject;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.Toast;

public class AndroidDialogs extends Extension {
    private static Toast toast;
    private static AlertDialog.Builder dialogBuilder;
    private static HaxeObject objHaxe;

    public static void showToast(String msg, int d) {
        int duration = (d == 1) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG;
        runOnUiThread(() -> {
            if (toast != null) toast.cancel();
            toast = Toast.makeText(mainContext, msg, duration);
            toast.show();
        });
    }

    public static void showAlertDialog(String t, String msg, String conftext, String cltext, HaxeObject hxo) {
        runOnUiThread(() -> {
            dialogBuilder = new AlertDialog.Builder(mainContext);
            dialogBuilder.setTitle(t);
            dialogBuilder.setMessage(msg);
            dialogBuilder.setCancelable(false);
            dialogBuilder.setPositiveButton(conftext, (dialog, id) -> sendDialogResult(conftext));
            dialogBuilder.setNegativeButton(cltext, (dialog, id) -> sendDialogResult(cltext));
            dialogBuilder.show();
            objHaxe = hxo;
        });
    }

    public static void showDialogSelectSimpleRadio(String t, String[] op, HaxeObject hxo) {
        runOnUiThread(() -> {
            dialogBuilder = new AlertDialog.Builder(mainContext);
            dialogBuilder.setTitle(t);
            dialogBuilder.setSingleChoiceItems(op, -1, (dialog, item) -> objHaxe.call("onOptionSelected", new Object[]{op[item]}));
            dialogBuilder.show();
            objHaxe = hxo;
        });
    }

    public static void showDialogSelectMultiple(String t, String[] op, HaxeObject hxo) {
        runOnUiThread(() -> {
            dialogBuilder = new AlertDialog.Builder(mainContext);
            dialogBuilder.setTitle(t);
            boolean[] selecteds = new boolean[op.length];
            dialogBuilder.setMultiChoiceItems(op, selecteds, (dialog, item, isChecked) -> {
                selecteds[item] = isChecked;
                objHaxe.call("onOptionMultipleSelected", new Object[]{selecteds});
            });
            dialogBuilder.show();
            objHaxe = hxo;
        });
    }

    private static void sendDialogResult(String result) {
        if (objHaxe != null) objHaxe.call("onMessageReceived", new Object[]{result});
    }

    private static void runOnUiThread(Runnable runnable) {
        mainActivity.runOnUiThread(runnable);
    }
}
