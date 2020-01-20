
// OS_reader_writer_windows.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//

#include <iostream>
#include <Windows.h>

#define OK EXIT_SUCCESS
#define ERROR EXIT_FAILURE

#define READERS_N 5
#define WRITERS_N 3

#define SLEEP_READER 3000
#define SLEEP_WRITER 5000

HANDLE mutex;
HANDLE can_read, can_write;

// arrays
HANDLE readers[READERS_N];
HANDLE writers[WRITERS_N];

// global vars
volatile LONG active_readers = 0;
volatile LONG waiting_readers = 0;
volatile LONG waiting_writers = 0;
bool is_writing = FALSE;

int value = 0;

int init_handles();
inline void close_handle(HANDLE handle);
void close_handles();

int create_threads();

void start_read();
void stop_read();
void start_write();
void stop_write();

DWORD WINAPI reader(LPVOID);
DWORD WINAPI writer(LPVOID);

int main()
{
	if (init_handles() == ERROR ||
		create_threads() == ERROR) {
		return ERROR;
	}

	WaitForMultipleObjects(READERS_N, readers, TRUE, INFINITE);
	WaitForMultipleObjects(WRITERS_N, writers, TRUE, INFINITE);

	close_handles();

	return OK;
}

int init_handles() {

	if (!(mutex = CreateMutex(NULL, false, NULL))) {
		puts("Can't create mutex");
	}
	else if (!(can_read = CreateEvent(NULL, FALSE, TRUE, NULL))) {
		puts("Can't create event can_read");
	}
	else if (!(can_write = CreateEvent(NULL, FALSE, TRUE, NULL))) {
		puts("Cant't create event can_write");
	}
	else {
		return OK;
	}

	close_handles();
	return ERROR;
}

inline void close_handle(HANDLE handle) {
	if (handle) {
		CloseHandle(handle);
	}
}

void close_handles() {
	close_handle(mutex);
	close_handle(can_read);
	close_handle(can_write);
}

int create_threads() {

	for (int i = 0; i < READERS_N; i++) {
		if (!(readers[i] = CreateThread(NULL, 0, reader, NULL, 0, NULL))) {
			puts("Can't create reader");
			return ERROR;
		}
	}

	for (int i = 0; i < WRITERS_N; i++) {
		if (!(writers[i] = CreateThread(NULL, 0, writer, NULL, 0, NULL))) {
			puts("Can't create reader");
			return ERROR;
		}
	}

	return OK;
}

DWORD WINAPI reader(LPVOID) {

	while (1) {
		start_read();

		printf("\tReader #%ld read %d\n", GetCurrentThreadId(), value);

		stop_read();
		Sleep(SLEEP_READER);
	}

}

DWORD WINAPI writer(LPVOID) {

	while (1) {
		start_write();

		printf("Writer #%ld wrote %d\n", GetCurrentThreadId(), ++value);

		stop_write();
		Sleep(SLEEP_WRITER);
	}

}

void start_read() {
	InterlockedIncrement(&waiting_readers);
	if (is_writing || WaitForSingleObject(can_write, 0) == WAIT_OBJECT_0) {
		WaitForSingleObject(can_read, INFINITE);
	}
	InterlockedDecrement(&waiting_readers);
	InterlockedIncrement(&active_readers);

	SetEvent(can_read);
}

void stop_read() {
	InterlockedDecrement(&active_readers);

	if (active_readers == 0) {
		SetEvent(can_write);
	}
}

void start_write() {
	InterlockedIncrement(&waiting_writers);

	if (is_writing || active_readers > 0) {
		WaitForSingleObject(can_write, INFINITE);
	}
	WaitForSingleObject(mutex, INFINITE);
	InterlockedDecrement(&waiting_writers);

	is_writing = true;
	ReleaseMutex(mutex);
}

void stop_write() {

	is_writing = false;
	if (WaitForSingleObject(can_read, 0) == WAIT_OBJECT_0) {
		SetEvent(can_read);
	}
	else {
		SetEvent(can_write);
	}

}