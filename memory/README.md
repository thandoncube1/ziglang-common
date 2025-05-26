# Compile Time Known vs Runtime Known

- The Zig compiler cares about knowing the length/size of an object rather than its actual value
  If the Zig compiler knows the value of an object , then it automatically knows the size of the object.
  Because it can simply calculate the size ofCompile time = What the compiler can figure out by reading your code
  Runtime = What actually happens when someone runs your program

---

Think of it like a recipe: compile time is when you read the recipe and know you need 3 eggs,
runtime is when you actually crack those 3 eggs into the bowl. the object by looking at the size of the value.

---

```zig

    fn input_length(input: []const u8) usize {
        const n = input.len;
        return n;
    }

    pub fn main() !void {
        const name = "Pedro";
        const array = [_]u8 {1, 2, 3, 4};
        _ = name; _ = array;
    }

```

The other side of the spectrum are objects whose values are not known at compie time. Function arguments are not
known, they depend on the value that you assign to this particular argument when you call the function.

## Global Data Register

The global data register is a specific section of the executable of your Zig program, that is responsible for
storing any value that is known at `compile-time`.

This memory space only exists to store literals, constants, boolean and primitive values at compile time.
Its not really important for you as a programmer since you can't control it or access it and does not affect your
program logic. It simply exists in your program.

## Stack

If a local object in your function is stored in the stack,
you should never return a pointer to this local object from from the function. Because this pointer will
always become undefined after the function returns, since the stack space of the function is destroyed/Freed at the end of
its scope. "What if you really need to use this local object in some way after the function returns?"

The same way you would do if this were a C or C++ program. By returning an address to an object stored in the heap.
The heap memory has a much more flexible lifecycle, and allows you to get a valid pointer to a local object
of a function that already returned from its scope.
