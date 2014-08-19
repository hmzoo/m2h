package m2h.tree;

class Arbo {
	
	private var parentArbo:Arbo;
	private var childsArbo:Array<Arbo>;
	private var leaves:Array<Leaf>;

	private var index:Leaf;


	private var fileName:String;

	private var level:Int;


	public function new(parentArbo:Arbo,fileName:String){

		this.childsArbo=[];
		this.leaves=[];
		this.parentArbo=parentArbo;

		this.fileName=fileName;

		this.level=0; 

		this.index= new Leaf(this,fileName);
		this.index.setSimpleName("index");


	}

	public function createArbo(fileName:String):Arbo{
		var arbo = new Arbo(this,fileName); 
		this.childsArbo.push(arbo);
		arbo.level=this.level+1;

		return arbo;
	}

	public function createLeaf(fileName:String):Leaf{
		var leaf = new Leaf(this,fileName);
		this.leaves.push(leaf);

		return leaf;
	}



	public function getChildsIterator():Iterator<Arbo>{
		return this.childsArbo.iterator();
	}

	public function getLeavesIterator():Iterator<Leaf>{
		return this.leaves.iterator();
	}


	public function getIndex():Leaf{
		return this.index;
	}

	public function getTitle():String{
		return this.index.getTitle();
	}



	public function getParent():Arbo{
		return this.parentArbo;
	}

	public function getRoot():Arbo{
		if(parentArbo!=null){return parentArbo.getRoot();}
		return this;
	}

	public function getPrimary():Arbo{
		if(level==1){return this;}		
		if(level>1){return parentArbo.getPrimary();}
		if(level<1){return null;}

		return this;
	}

	public function getSecondary():Arbo{

		if(level>2){return parentArbo.getSecondary();}
		if(level==2){return this;}
		if(level<2){return null;}



		return this;
	}




	public function getLevel():Int{
		return this.level;
	}




public function getFileName():String{
	return this.fileName;
}


public function getPath(path:Array<String>):Array<String>{

	path.insert(0, fileName);

	if(parentArbo!=null){return parentArbo.getPath(path);}
	return path;
}


}
