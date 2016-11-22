/* File: ast_type.h
 * ----------------
 * In our parse tree, Type nodes are used to represent and
 * store type information. The base Type class is used
 * for built-in types, the NamedType for classes and interfaces,
 * and the ArrayType for arrays of other types.  
 */
 
#ifndef _H_ast_type
#define _H_ast_type

#include "ast.h"
#include "list.h"
#include "ast_stmt.h"
#include "hashtable.h"
extern Hashtable<Type*> *typesTable;
class Type : public Node 
{
  protected:
    

  public :
    static Type *intType, *doubleType, *boolType, *voidType,
                *nullType, *stringType, *errorType;

    Type(yyltype loc) : Node(loc) {}
    Type(const char *str);
    char *typeName;
    const char *GetPrintNameForNode() { return "Type"; }
    void BuildChildren();
    
};

class NamedType : public Type 
{
  protected:
    
    
  public:
    NamedType(Identifier *i);
    Identifier *id;
    const char *GetPrintNameForNode() { return "NamedType"; }
    void BuildChildren();
};

class ArrayType : public Type 
{
  protected:
    Type *elemType;

  public:
    ArrayType(yyltype loc, Type *elemType);
    
    const char *GetPrintNameForNode() { return "ArrayType"; }
    void BuildChildren();
};

 
#endif
