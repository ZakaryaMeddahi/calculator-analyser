%{
#undef yywrap
#define yywrap() 1
#include<stdio.h>
#include<string.h>
int yyerror(char *msg);
char file[100];
char expression[50];
int expression_length;
char parentheses_stack[50];
int parth_stack_length = 0;
char expression_stack[50][50];
int exp_stack_length = 0;
int i = 0;
int ascii_value;
char operand[7];
int operand_length = 0;
int is_new_operation = 1;
int nbrLines = 1;
%}

%%

[0-9a-zA-Z*\-+/()]+ {
  printf("true: %s\n", yytext);
  strcpy(expression, yytext);
  expression_length = yyleng;
  while(expression[i] != '\0') {
    ascii_value = expression[i];

    if(is_new_operation) {
      is_new_operation = 0;
      if(!(ascii_value >= 48 && ascii_value <= 59 || 
        ascii_value >= 65 && ascii_value <= 90 || 
        ascii_value >= 97 && ascii_value <= 122) && expression[i] != '(') {
          printf("Error Lexical: expression should start with '(' or operand in line %d and column %d!\n", nbrLines, i);
      }
    }

    if(ascii_value >= 48 && ascii_value <= 59 || 
    ascii_value >= 65 && ascii_value <= 90 || 
    ascii_value >= 97 && ascii_value <= 122) {
      operand[operand_length] = expression[i];
      // printf("%c\n", expression[i]);
      operand_length++;
      // printf("Operand\n");
      if(expression[i+1] == '/' || 
        expression[i+1] == '*' || 
        expression[i+1] == '+' || 
        expression[i+1] == '-' || 
        expression[i+1] == ')') {
        strcpy(expression_stack[exp_stack_length], operand);
        exp_stack_length++;
        for(int j = 0; j < operand_length; j++) {
          operand[j] = '\0';
        }
        operand_length = 0;
      }
      printf("expression_stack: %s\n", expression_stack[--exp_stack_length]);
      // if(expression[i] == )
    } else if(expression[i] == '(') {
      // printf("Parentheses\n");
      parentheses_stack[parth_stack_length] = '(';
      parth_stack_length++;
      is_new_operation = 1;
    } else if(expression[i] == ')') {
      parth_stack_length--;
      parentheses_stack[parth_stack_length] = ' ';
    } else if(expression[i] == '/' || 
        expression[i] == '*' || 
        expression[i] == '+' || 
        expression[i] == '-') {
      // printf("Operation\n");
    } else {
      printf("Lexical Error in line %d and column %d!\n", nbrLines, i);
    }
    i++;
  }

  printf("Stack Length: %d\n", parth_stack_length);
  if(parth_stack_length) {
    printf("Lexical Error: too many parentheses!\n");
  }

  for(int j = 0; j < operand_length; j++) {
    operand[j] = '\0';
  }
}

[\n] {nbrLines++;}
. {yyerror("Lexical Error");}

%%

yyerror(char *msg) {
  printf("%s: %s\n", msg, yytext);
}

main() {
  printf("Donner le nom de fechier: ");
  scanf("%s", &file);
  yyin = fopen(file, "r");
  yylex();
  // printf("%s\n", expression);
}