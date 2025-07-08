//
//  NotesListView.swift
//  SurvAPP
//
//  Created by D K on 08.07.2025.
//

import Foundation
// NotesListView.swift
import SwiftUI

struct NotesListView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NotesViewModel()
    @State private var showDetailView = false
    @State private var selectedNote: Note? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("icon_back_arrow") 
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 34)
                                .colorInvert()
                                .colorMultiply(.yellow)
                        }
                        
                        Spacer()
                        
                        Text("Explorer's Log")
                            .font(.custom("PaytoneOne-Regular", size: 24))
                            .foregroundColor(.primaryText)
                            .padding(.trailing, 40)
                        
                        Spacer()
                       
                    }
                    .padding()
                    
                    // Content
                    if viewModel.notes.isEmpty {
                        emptyStateView
                    } else {
                        notesList
                    }
                }
            }
            .sheet(isPresented: $showDetailView) {
                NoteDetailView(viewModel: viewModel, noteToEdit: selectedNote)
            }
        }
    }
    
    // View for when there are no notes
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("You have no notes") // Corrected grammar
                .font(.headline)
                .foregroundStyle(Color.lightPurpleText)
            
            Button("+ Add note") {
                selectedNote = nil
                showDetailView = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 60)
            .padding(.top)
            Spacer()
        }
    }
    
    // View for the list of notes
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.notes) { note in
                    noteRow(for: note)
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Button("+ Add note") {
                selectedNote = nil
                showDetailView = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
    }
    
    // A single row in the notes list
    @ViewBuilder
    private func noteRow(for note: Note) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(note.date, style: .date)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentYellow)
                
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(Color.lightPurpleText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.deleteNote(note)
                }
            } label: {
                Image(systemName: "trash")
                    .font(.title3)
                    .foregroundStyle(Color.lightPurpleText.opacity(0.7))
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            selectedNote = note
            showDetailView = true
        }
    }
}

#Preview {
    NotesListView()
}

// NoteDetailView.swift
import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel
    
    var noteToEdit: Note?
    
    @State private var content: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("icon_back_arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34)
                            .colorInvert()
                            .colorMultiply(.yellow)
                    }
                    
                    Spacer()
                    
                    Text("Note details")
                        .font(.custom("PaytoneOne-Regular", size: 24))
                        .foregroundColor(.primaryText)
                        .padding(.trailing, 40)
                    
                    Spacer()
                }
                
                // Date Picker
                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: .date
                )
                .padding()
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .colorScheme(.dark) // Ensures calendar text is white
                .tint(Color.accentYellow) // Makes the selection yellow
                
                // Text Editor
                TextEditor(text: $content)
                    .scrollContentBackground(.hidden) // Allows custom background
                    .padding()
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(Color.lightPurpleText)
                    .tint(Color.accentYellow) // Makes the cursor yellow
                
                // Save Button
                HStack {
                    Spacer()
                    Button("Save") {
                        saveNote()
                    }
                    .buttonStyle(AccentButtonStyle())
                    Spacer()
                }
                .padding(.top)
                
            }
            .padding()
        }
        .onAppear(perform: setupView)
    }
    
    private func setupView() {
        if let note = noteToEdit {
            content = note.content
            date = note.date
        }
    }
    
    private func saveNote() {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Don't save empty notes
            return
        }
        viewModel.addOrUpdateNote(content: content, date: date, for: noteToEdit)
        dismiss()
    }
}

#Preview {
    // A preview needs a view model to work
    NoteDetailView(viewModel: NotesViewModel())
}
