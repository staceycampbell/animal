/*
 * Animal - copyright HCR Corporation, Toronto, Canada, 1989
 *
 * author: Stacey Campbell
 */

#include <curses.h>

#define HEAD "Animal"

static WINDOW *Header;
static WINDOW *FileMsg;
static WINDOW *QuestAns;
static WINDOW *QuestAnsBorder;

void InitCurses()

	{
	initscr();
#ifdef BOGUS_ECHO
	echo();
#endif
	werase(stdscr);
#ifdef BOGUS_BOX
	box(stdscr, '|', '-');
#else
	box(stdscr, 0, 0);
#endif
	wrefresh(stdscr);
	Header = newwin(1, COLS - 2, 1, 1);
	wstandout(Header);
	mvwaddstr(Header, 0, (COLS - 2) / 2 - sizeof(HEAD) / 2 - 1, HEAD);
	wstandend(Header);
	wrefresh(Header);
	FileMsg = newwin(3, COLS - 2, 2, 1);
#ifdef BOGUS_BOX
	box(FileMsg, '|', '-');
#else
	box(FileMsg, 0, 0);
#endif
	QuestAnsBorder = newwin(LINES - 6, COLS - 2, 5, 1);
#ifdef BOGUS_BOX
	box(QuestAnsBorder, '|', '-');
#else
	box(QuestAnsBorder, 0, 0);
#endif
	QuestAns = newwin(LINES - 8, COLS - 4, 6, 2);
	wmove(QuestAns, 0, 0);
	scrollok(QuestAns, TRUE);
	idlok(QuestAns, TRUE);
	wrefresh(FileMsg);
	wrefresh(QuestAnsBorder);
	wrefresh(QuestAns);
	return;
	}

char *FileQuestion(prompt)

char *prompt;

	{
	static char answer[256];

	werase(FileMsg);
#ifdef BOGUS_BOX
	box(FileMsg, '|', '-');
#else
	box(FileMsg, 0, 0);
#endif
	mvwaddstr(FileMsg, 1, 1, prompt);
	waddch(FileMsg, ' ');
#ifdef BOGUS_GET
	wrefresh(FileMsg);
#endif
	wgetstr(FileMsg, answer);
	return answer;
	}

void PutFileMsg(str)

char *str;

	{
	werase(FileMsg);
#ifdef BOGUS_BOX
	box(FileMsg, '|', '-');
#else
	box(FileMsg, 0, 0);
#endif
	mvwaddstr(FileMsg, 1, 1, str);
	wrefresh(FileMsg);
	}

void EndCurses()

	{
	delwin(Header);
	delwin(FileMsg);
	delwin(QuestAns);
	delwin(QuestAnsBorder);
	endwin();
	}

void PutQuestion(question)

char *question;

	{
	wprintw(QuestAns, "%s?", question);
	}

void PutFinalQuestion(question)

char *question;

	{
	char buf[256];
	void PutQuestion();

	strcpy(buf, "final guess: is it ");
	strcat(buf, question);
	PutQuestion(buf);
	}

void PutMsg(msg)

char *msg;

	{
	waddstr(QuestAns, msg);
	waddch(QuestAns, '\n');
	}

void GetQuestLine(prompt, reply)

char *prompt;
char *reply;

	{
	wprintw(QuestAns, "%s ", prompt);
#ifdef BOGUS_GET
	wrefresh(QuestAns);
#endif
	wgetstr(QuestAns, reply);
	}

void StartBold()

	{
	wstandout(QuestAns);
	}

void EndBold()

	{
	wstandend(QuestAns);
	}
