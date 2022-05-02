#include "main.h"

extern "C" {
static volatile struct limine_terminal_request term_req = {
	.id = LIMINE_TERMINAL_REQUEST,
	.revision = 0};

[[noreturn]] static void done()
{
	while (true)
		asm("hlt");
}

void _start()
{
	if (term_req.response == nullptr || term_req.response->terminal_count < 1) {
		done();
	}

	struct limine_terminal *term = term_req.response->terminals[0];
	term_req.response->write(term, "Welcome to merlin", 17);
	done();
}
}