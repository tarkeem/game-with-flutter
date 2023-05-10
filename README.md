1-templetes

actually this concepts is not directly available in java script as it is interpretor language.

but we could simulating the temblet concept as we have learned

2-subprograms as parameters

actully this concept is wide popular in java script.

as we see in example bellow:

fun1(x,y)

{

var c=x+y

teturn c;

} 

fun 2(anotherFun)

{

var res= anotherFun(5,6);

console.log(res);

}

3-type-less parameter

as we have learned most of language when we are trying to define or call a function so we have to specify the typies of parameters as fun(int x,string y);

so can we do something like that in java script

No, JavaScript is not a statically typed language.

Sometimes you may need to manually check types of parameters in your function body.

example:

function fun(x,y)

{

var a=x

var b=y

}

as we can notice we did not write the type of function parameters.

4-Polymorphism

java script provides us with this concept 

example:

class animal {
    print() {
        console.log("i am animal")
    }
}
class lion extends animal {
    peinr {
        console.log("i am lion");
    }
}
class tiger extends animal {
    print {
        console.log("i am tiger")
    }
}
let ob = new animal();
let ob2 = new lion();
let ob3 = new tiger();
ob.print();//i am animal
ob2.print();// i am lion
ob3.print();//i am tiger

class A {
    area(x, y) {
        console.log(x * y);
    }
}
class B extends A {
    area(a, b) {
        super.area(a, b);
        console.log('Class B')
    }
}
let ob = new B();
let output = ob.area(100, 200);



