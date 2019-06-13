#include <stdio.h>
					
extern float my_sin(float arg);

int main()
{
    float argument;
    printf("Podaj argument dla sinusa:\n");
    scanf("%f", &argument);
	printf("Sinus dla %f:\n%f\n", argument, my_sin(argument));
	return 0;
}