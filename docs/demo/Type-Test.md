[Demos and Examples](README.md)

# Test a PL/SQL Type

---

## PL/SQL Types
* Attributes
* VArray
* Nested Table
* Object

## Test a PL/SQL Object Type

Create a simple object type to test.

Run this:

```
create or replace type simple_test_obj_type authid definer
   as object
   (l_minimum      number
   ,l_observations  number
   ,CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
       return self as result
   ,member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
   );
/
```

And run this:

```
create or replace type body simple_test_obj_type is
    CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
          return self as result
    is
    begin
       l_minimum      := null;
       l_observations := 0;
       return;
    end simple_test_obj_type;
    member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
    is
    begin
       If l_minimum is null then l_minimum := in_observation;
       else l_minimum := least(l_minimum, in_observation);
       end if;
       l_observations := l_observations + 1;
    end add_observation;
end;
```

## Testing Private Object Methods and Self-Testing

An Oracle object type can have private methods.  These methods are not available outside the object.  They are inherited from a super-type.

[Private Object Methods on StackOverFlow](https://stackoverflow.com/questions/1580205/pl-sql-private-object-method)

Testing these private methods requires a mock object type of the super-type that exposes the private methods for testing.

Self-testing object types has the drawback of requires a CONSTRUCTOR FUNCTION with no parameters.  This limits testing of the object to that one constructor.

---
[Demos and Examples](README.md)
