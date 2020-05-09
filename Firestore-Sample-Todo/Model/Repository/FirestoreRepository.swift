//
//  FireStoreRepository.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/03.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FirestoreRepository {
    func createCategory(title: String, editDate: Date, _ completion: @escaping (Result<Void, Error>) -> ())
    func readCategories(_ completion: @escaping (Result<[Category], Error>) -> ())
    func updateCategory(_ category: Category, _ completion: @escaping (Result<Void, Error>) -> ())
    func deleteCategory(by id: String, _ completion: @escaping (Result<Void, Error>) -> ())
    func createTodo(title: String, content: String, editDate: Date, categoryId: String,
                    _ completion: @escaping (Result<Void, Error>) -> ())
    func readTodoList(with categoryId: Int, _ completion: @escaping (Result<[Todo], Error>) -> ())
    func readAllCategoryTodoList(_ completion: @escaping (Result<[Todo], Error>) -> ())
    func updateTodo(_ todo: Todo, _ completion: @escaping (Result<Void, Error>) -> ())
    func deleteTodo(by id: String, _ completion: @escaping (Result<Void, Error>) -> ())
}

struct FirestoreRepositoryImpl: FirestoreRepository {

    private let db = Firestore.firestore()

    func createCategory(title: String, editDate: Date, _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("categories").addDocument(data: [
            "title": title,
            "editDate": editDate
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func readCategories(_ completion: @escaping (Result<[Category], Error>) -> ()) {
        db.collection("categories").order(by: "editDate", descending: false).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let categories = snapshot?.documents.compactMap({ doc -> Category? in
                    guard let title = doc.data()["title"] as? String,
                        let editDate = (doc.data()["editDate"] as? Timestamp)?.dateValue() else { return nil }
                    return Category(id: doc.documentID, title: title, editDate: editDate)
                })
                completion(.success(categories ?? []))
            }
        }
    }

    func updateCategory(_ category: Category, _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("categories").document(category.id).setData( [
            "title": category.title,
            "editDate": category.editDate
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteCategory(by id: String, _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("categories").document(id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func createTodo(title: String, content: String, editDate: Date, categoryId: String,
                    _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("todoList").addDocument(data: [
            "title": title,
            "content": content,
            "editDate": editDate,
            "categoryId": categoryId
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func readTodoList(with categoryId: Int, _ completion: @escaping (Result<[Todo], Error>) -> ()) {
        db.collection("todoList").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success([]))
            }
        }
    }

    func readAllCategoryTodoList(_ completion: @escaping (Result<[Todo], Error>) -> ()) {
        db.collection("todoList").order(by: "editDate", descending: false).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let categories = snapshot?.documents.compactMap({ doc -> Todo? in
                    guard let title = doc.data()["title"] as? String,
                        let content = doc.data()["content"] as? String,
                        let editDate = (doc.data()["editDate"] as? Timestamp)?.dateValue(),
                        let categoryId = doc.data()["categoryId"] as? String else { return nil }
                    return Todo(id: doc.documentID, title: title, content: content, editDate: editDate, categoryId: categoryId)
                })
                completion(.success(categories ?? []))
            }
        }
    }

    func updateTodo(_ todo: Todo, _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("todoList").document(todo.id).setData( [
            "title": todo.title,
            "content": todo.content,
            "editDate": todo.editDate,
            "categoryId": todo.categoryId
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteTodo(by id: String, _ completion: @escaping (Result<Void, Error>) -> ()) {
        db.collection("todoList").document(id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
