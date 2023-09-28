void dummy(){

}

void main(){
	char* vram = (char*) 0xb8000;
	*vram = 'X';
}
