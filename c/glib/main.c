#include "header.h"

int main(int argc, char **argv) {
	
	GHashTable *ht = g_hash_table_new(NULL, NULL);
	
	gpointer key = (gpointer) 4;
	gpointer val = (gpointer) 65;
	
	g_hash_table_insert(ht, key, val);	
	
	gpointer x = g_hash_table_lookup(ht, key);
	printf("key of %d, val of %d, got %d\n", (int) key, (int) val, (int) x);
	
}
