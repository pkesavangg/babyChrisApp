//
//  Protocols.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 01/04/23.
//

import Foundation

protocol ToastDelegate {
    func showToast(toastData: ToastModifier.ToastData, showToast: Bool)
}

protocol LoaderDelegate {
    func showLoader(loaderMessage: String, isLoading: Bool)
}


