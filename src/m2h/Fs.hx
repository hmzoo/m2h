package m2h;

import cpp.Lib;
import sys.io.File;
import haxe.io.Bytes;


class Fs {



static public function list(path):Array<String>{


	return sys.FileSystem.readDirectory(path);
}

static public function isdir(path):Bool{
 
	path=haxe.Utf8.decode(path);

	return sys.FileSystem.isDirectory(path);
}

static public function path(path):String{

	path=haxe.Utf8.decode(path);

	return sys.FileSystem.fullPath(path);
} 

static public function mkdir(path:String){

	path=haxe.Utf8.decode(path);

	sys.FileSystem.createDirectory(path);
}

static public function rmdir(path:String){

	path=haxe.Utf8.decode(path);

	sys.FileSystem.deleteDirectory(path);
}

static public function save(path:String,datas:String){

	path=haxe.Utf8.decode(path);

	sys.io.File.saveContent(path,datas);
}

static public function saveBytes(path:String,datas:Bytes){


	sys.io.File.saveBytes(path,datas);
}

static public function load(path):String{


	path=haxe.Utf8.decode(path);


	return sys.io.File.getContent(path);

}

static public function exists(path:String):Bool{
	path=haxe.Utf8.decode(path);

	return sys.FileSystem.exists(path);
}


static public function join(paths:Array<String>):String{


return haxe.io.Path.join(paths);

}

static public function copy(srcPath:String, dstPath:String):Void{

	srcPath=haxe.Utf8.decode(srcPath);
	dstPath=haxe.Utf8.decode(dstPath);

if(exists(srcPath)&&!isdir(srcPath)){
	
	sys.io.File.copy(srcPath, dstPath);
}
}


static public function checkFileName(filename:String):Bool{
	var regex=~/([^\w.])/;
	var result=regex.match(filename);
	if(result){
	Fs.alert("BAD FILENAME",filename+" "+regex.matched(1));
	}
	return !result;
}

static public function alert(type:String, message:String){

Lib.println(type+"\t  : "+message);


}


}